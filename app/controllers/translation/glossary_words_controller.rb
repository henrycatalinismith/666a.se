class Translation::GlossaryWordsController < ApplicationController
  layout "internal"

  def index
    @words = Translation::GlossaryWord.lexicographical.all
  end

  def show
    @word = Translation::GlossaryWord.find_by(word_slug: params[:word_slug])
    if @word.nil?
      raise ActiveRecord::RecordNotFound
    end
  end
end
