require 'test_helper'

module ShopifyCli
  module Commands
    class Populate
      class ResourceTest < MiniTest::Test
        include TestHelpers::Context
        include TestHelpers::Schema

        def setup
          super
          Helpers::AccessToken.stubs(:read).returns('myaccesstoken')
          @context.stubs(:project).returns(
            Project.at(File.join(FIXTURE_DIR, 'app_types/node'))
          )
        end

        def test_with_schema_args_overrides_input
          resource = Product.new(ctx: @context, args: [
            '-c 1', '--title="bad jeggings"', '--variants=[{price: "4.99"}]'
          ])
          assert_equal('"bad jeggings"', resource.input.title)
          assert_equal('[{price: "4.99"}]', resource.input.variants)
        end

        def test_populate_runs_mutation_default_number_of_times
          resource = Product.new(ctx: @context, args: [])
          resource.expects(:run_mutation).times(Product::DEFAULT_COUNT)
          resource.populate
        end

        def test_populate_runs_mutation_count_number_of_times
          resource = Product.new(ctx: @context, args: ['-c 2'])
          resource.expects(:run_mutation).times(2)
          resource.populate
        end
      end
    end
  end
end
