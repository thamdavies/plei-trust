class Permission < ApplicationRecord
  belongs_to :parent, class_name: "Permission", optional: true
  has_many :children, class_name: "Permission", foreign_key: :parent_id, dependent: :restrict_with_exception
  has_many :role_permissions, dependent: :restrict_with_exception
  has_many :roles, through: :role_permissions

  normalizes :key, with: ->(key) { key.strip }

  validates :key, :label, :category, presence: true
  validates :key, uniqueness: true
  validate :parent_cannot_be_self

  def descendant_action_permissions
    if assignable?
      [self]
    else
      children.order(:sort_order, :key).flat_map(&:descendant_action_permissions)
    end
  end

  private

  def parent_cannot_be_self
    errors.add(:parent, "cannot be itself") if parent_id.present? && parent_id == id
  end
end
