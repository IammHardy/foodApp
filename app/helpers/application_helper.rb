module ApplicationHelper
  # Tailwind pagination for Kaminari
  def tailwind_paginate(collection)
    return "" unless collection.total_pages > 1

    content_tag :nav, role: "navigation", aria: { label: "Pagination" }, class: "flex justify-center mt-6 gap-1" do
      safe_join([
        # Previous page
        (link_to "«", url_for(page: collection.prev_page), class: prev_page_classes(collection), disabled: collection.first_page?) ,

        # Page numbers
        safe_join(collection.each_page.map do |page|
          if page == collection.current_page
            content_tag(:span, page, class: "px-3 py-1 rounded bg-red-600 text-white font-semibold")
          else
            link_to page, url_for(page: page), class: "px-3 py-1 rounded bg-gray-200 text-gray-700 hover:bg-red-600 hover:text-white"
          end
        end),

        # Next page
        (link_to "»", url_for(page: collection.next_page), class: next_page_classes(collection), disabled: collection.last_page?)
      ].compact)
    end
  end

  private

  def prev_page_classes(collection)
    base = "px-3 py-1 rounded font-semibold"
    collection.first_page? ? "#{base} bg-gray-200 text-gray-400 cursor-not-allowed" : "#{base} bg-red-600 text-white hover:bg-red-700"
  end

  def next_page_classes(collection)
    base = "px-3 py-1 rounded font-semibold"
    collection.last_page? ? "#{base} bg-gray-200 text-gray-400 cursor-not-allowed" : "#{base} bg-red-600 text-white hover:bg-red-700"
  end
end
