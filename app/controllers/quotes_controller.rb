# frozen_string_literal: true

class QuotesController < ApplicationController
  before_action :confirm_admin, except: [:index]
  before_action :set_quote, only: [:edit, :update, :destroy]

  # GET /quotes
  def index
    @search_term = params[:search]
    @quotes =
      Quote
      .filtered(params[:search])
      .joins(:author)
      .order('authors.slug')
      .page(params[:page])
      .per(12)
  end

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
      redirect_to @quote.author, flash: { success: 'Quote was successfully created.' }
    else
      render :new
    end
  end

  # PATCH/PUT /quotes/{slug}
  def update
    if @quote.update(quote_params)
      redirect_to @quote.author, flash: { success: 'Quote was successfully updated.' }
    else
      render :edit
    end
  end

  # DELETE /quotes/{slug}
  def destroy
    next_route = @quote.author.quotes_count > 1 ? @quote.author : quotes_url
    if @quote.destroy
      redirect_to next_route, flash: { info: 'Quote was successfully destroyed.' }
    else
      render :edit
    end
  end

  private

  def set_quote
    @quote = Quote.includes(:author).find_by(slug: params[:slug])
  end

  def quote_params
    qp = params.fetch(:quote, {}).permit(:passage, :author_id, :search)
    qp.each { |_k, v| v.strip! if v.respond_to?('strip!') }
  end
end
