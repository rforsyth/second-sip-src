
class NotesController < ApplicationController
  
  # GET /notes/search
  def search
    @notes = @note_class.all
		render :template => 'notes/search'
  end
  
  # GET /notes
  def index
    @notes = @note_class.all
		render :template => 'notes/index'
  end

  # GET /notes/1
  def show
    @note = @note_class.find(params[:id])
		render :template => 'notes/show'
  end

  # GET /notes/new
  def new
    @note = @note_class.new
		render :template => 'notes/new'
  end

  # GET /notes/1/edit
  def edit
    @note = @note_class.find(params[:id])
    render :template => 'notes/edit'
  end

  # POST /notes
  def create
    @note = @note_class.new(params[:note])
    if @note.save
      redirect_to([@note.owner, @note], :notice => 'Note was successfully created.')
    else
      render :action => "new"
    end
  end

  # PUT /notes/1
  def update
    @note = @note_class.find(params[:id])
    if @note.update_attributes(params[:note])
      redirect_to([@note.owner, @note], :notice => 'Note was successfully updated.')
    else
      render :action => "edit"
    end
  end

  # DELETE /notes/1
  def destroy
    @note = @note_class.find(params[:id])
    @note.destroy
    redirect_to(notes_url)
  end
end
