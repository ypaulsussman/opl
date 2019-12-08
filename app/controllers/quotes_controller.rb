# frozen_string_literal: true

class QuotesController < ApplicationController
  before_action :confirm_admin, except: [:index, :show]
  before_action :set_quote, only: [:show, :edit, :update, :destroy]

  # GET /quotes
  def index
    @quotes = Quote.joins(:author).order(:sortable_name).page(params[:page])
  end

  # GET /quotes/{uuid}
  def show; end

  # GET /quotes/new
  def new
    @quote = Quote.new
  end

  # GET /quotes/{uuid}/edit
  def edit
    @all_authors = Author.order(:sortable_name)
  end

  # POST /quotes
  def create
    @quote = Quote.new(quote_params)

    if @quote.save
      redirect_to @quote, notice: 'Quote was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /quotes/{uuid}
  def update
    if @quote.update(quote_params)
      redirect_to @quote, notice: 'Quote was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /quotes/{uuid}
  def destroy
    @quote.destroy
    redirect_to quotes_url, notice: 'Quote was successfully destroyed.'
  end

  private

  def set_quote
    @quote = Quote.find(params[:id])
  end

  def quote_params
    params.fetch(:quote, {}).permit(:passage, :author_id)
  end
end
