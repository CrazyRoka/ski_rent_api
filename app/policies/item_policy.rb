class ItemPolicy < ApplicationPolicy
  def destroy?
    record.owner == user
  end

  def show?
    record.owner == user
  end
end