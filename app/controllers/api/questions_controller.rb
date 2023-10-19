require 'csv'
require 'matrix'

class Api::QuestionsController < ApplicationController
  def ask
    question = params[:question]
    if question[-1] != '?' then question += '?' end
    question_record = Question.find_by(question: question)
    if question_record
      answer = question_record.answer
    else
      answer = generate_answer(question)
      Question.create(question: question, answer: answer)
    end
    render json: { answer: answer }
  end

  private

  def cosine_similarity(vector1, vector2)
    dot_product = vector1.inner_product(vector2)
    magnitude1 = Math.sqrt(vector1.inner_product(vector1))
    magnitude2 = Math.sqrt(vector2.inner_product(vector2))
    return dot_product / (magnitude1 * magnitude2)
  end

  def get_chapters(question_embedding)
    similarities = []
    CSV.foreach(Rails.root.join('public', 'the-prince-embeddings.tsv'), headers: true, col_sep: "\t") do |row|
      chapter_number = row['Chapter Number'].to_i
      chapter_text = row['Chapter Text']
      chapter_embedding = row['Chapter Embedding'].split(', ').map(&:to_f)
      similarity = cosine_similarity(Vector[*chapter_embedding], Vector[*question_embedding])
      similarities << { chapter_number: chapter_number, chapter_text: chapter_text, similarity: similarity }
    end

    sorted_passages = similarities.sort_by { |sim| -sim[:similarity] }

    selected_chapters = []
    top_n = 1
    section_length = 3000
    sorted_passages.take(top_n).each do |sim|
      text = sim[:chapter_text]
      if text.length > section_length then text = text[0..section_length] + '...' end
      selected_chapters << text
    end
    selected_chapters
  end

  def construct_prompt(question, chapters)
    header = "Niccolo Machiavelli was an Italian diplomat, philosopher and historian, and the author of the book The Prince. Please answer as him. Please keep your answers to three sentences maximum, and speak in complete sentences. Stop speaking once your point is made.\n\nContext that may be useful, pulled from The Prince:\n"
    question = "\n\nQ: #{question}\nA:"
    header + chapters.join("\n\n") + question
  end

  def generate_answer(question)
    openai_client = OpenAI::Client.new(access_token: ENV["OPENAI_API_KEY"])
    question_embedding = openai_client.embeddings(
      parameters: {
        model: "text-embedding-ada-002",
        input: question,
      }
    )["data"][0]["embedding"]

    chapters = get_chapters(question_embedding)

    prompt = construct_prompt(question, chapters)
    answer = openai_client.completions(
      parameters: {
        model: "gpt-3.5-turbo-instruct",
        prompt: prompt,
        max_tokens: 150,
        temperature: 0.0,
      }
    )['choices'][0]['text']
  end
end
