# frozen_string_literal: true
module HyraxHelper
  include ::BlacklightHelper
  include Hyrax::BlacklightOverride
  include Hyrax::HyraxHelperBehavior

  def form_tabs_for(form:)
    if form.instance_of? Hyrax::Forms::BatchUploadForm
      %w[files metadata relationships]
    else
      form.tabs
    end
  end

  def is_tombstonable?(presenter)
    presenter.tombstone_status != ['initiated'] && (is_published?(presenter) || is_archived?(presenter))
  end

  def is_published?(presenter)
    ['deposited', 'published'].include?(presenter.workflow.state)
  end

  def is_archived?(presenter)
    presenter.workflow.state == 'archived'
  end

  def tombstone_out_of_date?(presenter)
    ((Date.today) - presenter.tombstone_date.first.to_date).to_i >= ENV['NUMBER_OF_DAYS_TO_TOMBSTONE'].to_i
  end

  def is_tombston_initiated?(presenter)
    presenter.tombstone_status.present? && presenter.tombstone_status == ['initiated']
  end

  def is_permanently_tombstoned?(presenter)
    presenter.tombstone_status == ['deleted'] && presenter.is_tombstoned
  end

  def truncate_title(title)
    title.truncate(30)
  end

  # This method is used to get a Font Awesome class name or icon image path for different file types.
  # For example:
  #   file_icon_for('document.pdf') #=> "fa fa-file-pdf-o" OR "/pdf_icon.svg"
  def file_icon_for(file)
    extension = File.extname(file).downcase

    case extension
    when ".pdf"
      "fa fa-file-pdf-o"
    when ".doc", ".docx"
      "fa fa-file-word-o"
    when ".xls", ".xlsx", ".csv"
      "fa fa-file-excel-o"
    when ".ppt", ".pptx"
      "fa fa-file-powerpoint-o"
    when ".png", ".jpg", ".jpeg", ".gif", ".svg"
      "fa fa-file-image-o"
    when ".zip", ".rar", ".tar", ".gz"
      "fa fa-file-archive-o"
    when ".mp4", ".avi", ".mov", ".mkv", ".webm", ".wmv"
      "fa fa-file-video-o"
    when ".mp3", ".wav", ".ogg"
      "fa fa-file-audio-o"
    when ".txt", ".md", ".rtf", ".odt"
      "fa fa-file-text-o"
    when ".html", ".htm", ".xml"
      "fa fa-file-code-o"
    else
      "fa fa-file-o"
    end
  end
end
