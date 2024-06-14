class Glossary::WordsController < ApplicationController
  layout "internal"

  def index
    @words = Glossary::Word.lexicographical.all
  end

  def show
    @word = Glossary::Word.find_by(word_slug: params[:word_slug])
    if @word.nil?
      raise ActiveRecord::RecordNotFound
    end
  end
end
