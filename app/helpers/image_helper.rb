module ImageHelper
  def show_cards_image(card)
    image_tag(card.image.url) if card.image.file
  end
end