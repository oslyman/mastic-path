#!/usr/bin/env ruby

require 'openai'
require 'csv'

openai_client = OpenAI::Client.new(access_token: ENV["OPENAI_API_KEY"])

input_text = File.read('./the-prince.txt')

chapters = input_text.split(/CHAPTER/)

# Clean up specific to this text. Should be generalized in the future.
chapters = chapters.slice!(27..-1)
chapters[-1] = chapters[-1].split(/DESCRIPTION OF THE METHODS ADOPTED BY THE DUKE VALENTINO/)[0]

results = []

chapters.each_with_index do |chapter_text, index|
  chapter_number = index + 1
  chapter_text = chapter_text.strip.gsub(/\t/, '    ')

  next if chapter_text.empty?

  chapter_embedding = openai_client.embeddings(
    parameters: {
      model: "text-embedding-ada-002",
      input: chapter_text,
    }
  )["data"][0]["embedding"]

  puts "Chapter #{chapter_number} embedded."

  results << [chapter_number, chapter_text, chapter_embedding]
end

CSV.open('the-prince-embeddings.tsv', 'w', col_sep: "\t") do |csv|
  csv << ['Chapter Number', 'Chapter Text', 'Chapter Embedding']
  results.each do |result|
    csv << result
  end
end
