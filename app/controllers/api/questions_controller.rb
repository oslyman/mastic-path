class Api::QuestionsController < ApplicationController
  def ask
    question = params[:question]
    # Replace this with your logic to generate an answer based on the question.
    answer = generate_answer(question)
    render json: { answer: answer }
  end

  private

  def generate_answer(question)
    # Implement your logic here to generate an answer based on the question.
    # For now, let's just return a static answer.
    "This is the answer to your question: #{question}"
  end
end
