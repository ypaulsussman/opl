# frozen_string_literal: true

class QuotesController < ApplicationController
  before_action :set_quote, only: [:show, :edit, :update, :destroy]

  # GET /quotes
  # GET /quotes.json
  def index
    # @quotes = Quote.all
    @quotes = Quote.order(:passage).page params[:page]
  end

  # GET /quotes/{uuid}
  # GET /quotes/{uuid}.json
  def show
    puts "My params!: #{params}"
  end

  # GET /quotes/new
  def new
    @quote = Quote.new
  end

  # GET /quotes/{uuid}/edit
  def edit
    @all_authors = Author.by_surname
  end

  # POST /quotes
  # POST /quotes.json
  def create
    @quote = Quote.new(quote_params)

    respond_to do |format|
      if @quote.save
        format.html { redirect_to @quote, notice: 'Quote was successfully created.' }
        format.json { render :show, status: :created, location: @quote }
      else
        format.html { render :new }
        format.json { render json: @quote.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /quotes/{uuid}
  # PATCH/PUT /quotes/{uuid}.json
  def update
    respond_to do |format|
      if @quote.update(quote_params)
        format.html {
          redirect_to @quote, notice: 'Quote was successfully updated.'
        }
        format.json { render :show, status: :ok, location: @quote }
      else
        format.html { render :edit }
        format.json { 
          render json: @quote.errors, status: :unprocessable_entity
        }
      end
    end
  end

  # DELETE /quotes/{uuid}
  # DELETE /quotes/{uuid}.json
  def destroy
    @quote.destroy
    respond_to do |format|
      format.html { redirect_to quotes_url, notice: 'Quote was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_quote
      @quote = Quote.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def quote_params
      params.fetch(:quote, {}).permit(:passage)
    end
end
