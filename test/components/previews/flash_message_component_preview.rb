class FlashMessageComponentPreview < ViewComponent::Preview
  def default
    render "ui/flash-message", text: "This is a flash message"
  end
end
