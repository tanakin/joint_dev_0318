class Understanding < ApplicationRecord
  belongs_to :user
  belongs_to :text

  def self.update_understandings(text_id, user, understand)
    understanding = Understanding.find_by(text_id: text_id, user_id: user.id)
    unless understanding
      understanding = user.understandings.build(text_id: text_id)
    end
    understanding.understand = understand
    understanding.save
  end

  def self.understanding_chart_data(user)
    understandings = user.understandings
    understand = understandings.pluck(:understand)
    true_count = understand.count(true)
    false_count = understand.count(false)
    not_read_count = Text.count - (true_count + false_count)

    [true_count, false_count, not_read_count]
  end


  def self.replay_list(user)
    understands = user.understandings
    replay = []
    understands.each do |understand|
      replay << understand.text_id unless understand.understand
    end
    text_find(replay)
  end
  
  def self.not_read_list(user)
    understands = user.understandings.pluck(:text_id)
    text = Text.pluck(:id)
    not_read = text - understands
    text_find(not_read)
  end

  private

  def self.text_find(ids)
    Text.where(id: ids).sort
  end
end
