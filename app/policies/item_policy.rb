class ItemPolicy < ApplicationPolicy
  def update?
    record.owner == user
  end

  def destroy?
    record.owner == user
  end

  def show?
    record.owner == user
  end
end