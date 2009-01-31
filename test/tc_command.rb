require 'gli'
require 'test/unit'
require 'test/unit/ui/console/testrunner'

include GLI
class TC_testCommand < Test::Unit::TestCase

  def test_basic_command
    GLI.reset
    GLI.desc 'Some Global Option'
    GLI.switch :g
    glob = nil
    verbose = nil
    glob_verbose = nil
    configure = nil
    args = nil
    GLI.desc 'Some Basic Command'
    GLI.command :basic do |c|
      c.desc 'be verbose'
      c.switch :v
      c.desc 'configure something'
      c.default_value 'crud'
      c.flag [:c,:configure]
      c.action = Proc.new do |global_options,options,arguments|
        glob = global_options[:g] ? 'true' : 'false'
        verbose = options[:v] ? 'true' : 'false'
        glob_verbose = global_options[:v] ? 'true' : 'false'
        configure = options[:c]
        args = arguments
      end
    end
    args_args = [%w(-g basic -v -c foo bar baz quux), %w(-g basic -v --configure=foo bar baz quux)]
    args_args.each do |args|
      GLI.run(args)
      assert_equal('true',glob)
      assert_equal('true',verbose)
      assert_equal('false',glob_verbose)
      assert_equal('foo',configure)
      assert_equal(%w(bar baz quux),args)
    end
    args = %w(basic -c foo bar baz quux)
    GLI.run(args)
    assert_equal('foo',configure)
    assert_equal(%w(bar baz quux),args)

    args = %w(basic bar baz quux)
    GLI.run(args)
    assert_equal('crud',configure)
    assert_equal(%w(bar baz quux),args)
  end

  def test_command_create
    description = 'List all files'
    GLI.desc description
    GLI.command [:ls,:list] do |c|
    end
  end


end
