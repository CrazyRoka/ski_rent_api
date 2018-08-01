class ImportItemsCsv
  include Dry::Transaction

  step :validate
  step :create

  def validate(csv, user:)
    items = []
    CSV.parse(csv, headers: true) do |row|
      items << Item.new(row.to_h.merge(owner: user))
      return Failure('Invalid data') if items.last.invalid?
    end
    Success(items)
  end

  def create(items)
    return Failure('Nothing created') if items.empty?
    Success(Item.import(items))
  end
end
