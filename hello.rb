require 'dry/schema'
require 'dry/monads'

Dry::Schema.load_extensions(:monads)

class Example
  include Dry::Monads[:result]

  Schema = Dry::Schema.Params {
    required(:name).filled(:string, size?: 2..4)
  }

  def call(input)
    case Schema.(input).to_monad
    in Success(name:)
      "Hello #{name}" # name is captured from result
    in Failure(name:)
      "#{name} is not a valid name"
    end
  end
end

run = Example.new

run.('name' => 'Jane')   # => "Hello Jane"
run.('name' => 'Albert') # => "Albert is not a valid name"
