module ApplicationHelper
  def flash_background_color(type)
    case type.to_sym
    when :notice then "bg-green-500"
    when :alert  then "bg-red-500"
    when :error  then "bg-yellow-500"
    else "bg-gray-500"
    end
  end

  def page_title(title = "")
    base_title = "FragranceMe"
    title.present? ? "#{title} | #{base_title}" : base_title
  end

  def default_meta_tags
    {
      site: "FragranceMe",
      title: "FragranceMe",
      reverse: true,
      charset: "utf-8",
      description: "FragranceMeは、気になるフレグランスショップを簡単に見つけることができるサービスです。香り探しをもっと楽しく、快適に！",
      keywords: "Fragrance,フレグランス,香り",
      canonical: "https://www.fragrance-me.com/",
      separator: "|",
      og: {
        site_name: :site,
        title: :title,
        description: :description,
        type: "website",
        url: "https://www.fragrance-me.com/",
        image: image_url("ogp_03.jpg"),
        local: "ja-JP"
      },
      twitter: {
        card: "summary_large_image",
        image: image_url("ogp_03.jpg")
      }
    }
  end
end
