module ApplicationHelper
  def markdown(text)
    return '' if text.blank?

    # Process the markdown with GitHub-flavored markdown
    html = Commonmarker.to_html(text, 
      options: {
        parse: { smart: true },
        render: { 
          hardbreaks: true,
          github_pre_lang: true,
          unsafe: true,
          full_info_string: true
        },
        extension: {
          strikethrough: true,
          table: true,
          autolink: true,
          tasklist: true
        }
      }
    )
    
    # Post-process images to add our custom classes
    html.gsub!(/<img(.*?)>/) do |img_tag|
      if img_tag.include?('shields.io') || img_tag.include?('badge')
        # For badges, keep them inline with text
        img_tag.sub(/>$/, ' class="inline-block align-middle">')
      else
        # For regular images, make them responsive and contained
        img_tag.sub(/>$/, ' class="rounded-lg max-h-[512px] object-contain mx-auto">')
      end
    end

    # Add target="_blank" to all links
    html.gsub!(/<a(.*?)>/) do |link_tag|
      if !link_tag.include?('target=')
        link_tag.sub(/>$/, ' target="_blank" rel="noopener noreferrer">')
      else
        link_tag
      end
    end
    
    html.html_safe
  end

  def preview_text(text, words: 50)
    return '' if text.blank?
    
    # Split into words and take first n words
    preview = text.split(/\s+/).take(words).join(' ')
    # Add ellipsis if text was truncated
    preview += '...' if text.split(/\s+/).length > words
    preview
  end
end
