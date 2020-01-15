# frozen_string_literal: true

class QuotesController < ApplicationController
  before_action :confirm_admin, except: [:index, :show]
  before_action :set_quote, only: [:show, :edit, :update, :destroy]

  # GET /quotes
  def index
    @quotes =
      Quote
      .joins(:author)
      .order('authors.slug')
      .page(params[:page])
      .per(12)
  end

  # GET /quotes/{slug}
  def show; end

  # GET /quotes/new
  def new
    @quote = Quote.new
    @author_id = params[:author_id]
  end

  # GET /quotes/{slug}/edit
  def edit; end

  # POST /quotes
  def create
    @quote = Quote.new(quote_params)

    if @quote.save
      redirect_to @quote, notice: 'Quote was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /quotes/{slug}
  def update
    if @quote.update(quote_params)
      redirect_to @quote, notice: 'Quote was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /quotes/{slug}
  def destroy
    @quote.destroy
    redirect_to quotes_url, notice: 'Quote was successfully destroyed.'
  end

  private

  def set_quote
    @quote = Quote.includes(:author).find_by(slug: params[:slug])
  end

  def quote_params
    params.fetch(:quote, {}).permit(:passage, :author_id)
  end
end
