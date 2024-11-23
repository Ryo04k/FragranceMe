module ShopsHelper
  def render_rating(shop)
    full_stars = shop.rating.floor
    half_star = shop.rating - full_stars >= 0.5

    star_svg = '<svg class="w-4 h-4 text-yellow-400" fill="currentColor" viewBox="0 0 20 20"><path d="M10 15l-5.878 3.09 1.122-6.534L0 6.236l6.545-.954L10 0l2.455 5.282L20 6.236l-5.244 5.32 1.122 6.534z"></path></svg>'
    half_star_svg = '<svg class="w-4 h-4 text-yellow-400" fill="currentColor" viewBox="0 0 20 20"><defs><linearGradient id="half"><stop offset="50%" stop-color="currentColor"/><stop offset="50%" stop-color="currentColor" stop-opacity="0.5"/></defs><path d="M10 15l-5.878 3.09 1.122-6.534L0 6.236l6.545-.954L10 0l2.455 5.282L20 6.236l-5.244 5.32 1.122 6.534z" fill="url(#half)"></path></svg>'
    empty_star_svg = '<svg class="w-4 h-4 text-yellow-400" fill="currentColor" viewBox="0 0 20 20" opacity="0.5"><path d="M10 15l-5.878 3.09 1.122-6.534L0 6.236l6.545-.954L10 0l2.455 5.282L20 6.236l-5.244 5.32 1.122 6.534z"></path></svg>'

    rating_html = (star_svg * full_stars).html_safe
    rating_html += half_star_svg.html_safe if half_star
    rating_html += (empty_star_svg * (5 - full_stars - (half_star ? 1 : 0))).html_safe

    rating_html + content_tag(:p, shop.rating, class: "text-base text-yellow-400 font-semibold ml-2")
  end
end
