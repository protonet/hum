module ApplicationHelper

  def track_links(id, track)
    id = id + 1

    content_tag(:div, :id => "track-#{id}", :class => 'track') do
      content_tag(:div, :class => 'name') do
        link_to(track.display_name, '#', 'data-track-id' => track.id, 'data-track-name' => track.display_name)
      end +
      content_tag(:div, :class => 'queue') do
        link_to('Q+', '#', 'data-track-id' => track.id)
      end +
      content_tag(:div, nil, :class => 'clear')
    end
  rescue Exception => e
    logger.error "Error: #{e}"
    nil
  end
end
