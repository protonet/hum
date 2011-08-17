module ApplicationHelper

  def track_links(id, track)
    content_tag(:div, :id => "track-#{id}", :class => 'track') do
      content_tag(:div, :class => 'number') do
        link_to id, '#', 'data-track-id' => id, 'data-track-name' => track['filename']
      end +
      content_tag(:div, :class => 'name') do
        link_to track['filename'], '#', 'data-track-id' => id, 'data-track-name' => track['filename']
      end +
      content_tag(:div, nil, :class => 'clear')
    end
  rescue
    nil
  end
end
