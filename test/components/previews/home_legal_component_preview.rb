class HomeLegalComponentPreview < ViewComponent::Preview
  def home_legal
    render(HomeLegalComponent.new())
  end
end
