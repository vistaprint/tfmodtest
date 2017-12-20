# Terraform Module Testing

[![Build Status](https://travis-ci.org/vistaprint/tfmodtest.svg?branch=master)](https://travis-ci.org/vistaprint/tfmodtest)

Terraform Module Testing is a set of rake tasks to easily enable testing for Terraform Module developement. It allows developers to specify tests in a rake task to test remote infrastructure is created as expected when using a module. It then destroys the environment after the test has run.

Currently this repository is tightly coupled with AWS and has not been tested to work with other providers. We are actively working to change this and hope to have a more generic solution soon. If you would like to see support for your favourite cloud provider please have submit a pull request implementing support and we will be more than happy to merge your changes in.

# Installation
Add this line to your application's Gemfile:

`gem 'terraform_module_testing'`  

And then execute:

`$ bundle`  

Or install it yourself as:

`$ gem install terraform_module_testing`

## Getting started

### A Minimal Rakefile

In the root of your repository add a `Rakefile` with the following contents:

```ruby
require 'tfmodtest/module_tasks'
```

# Adding tests 

In your repository create `test/<my_module>/Rakefile` and add:

```ruby
namespace '<your_modules_namespace>' do
  # Required: Import TerraformDevKit base rake tasks.
  # Set the root path of our tests to our location. 
  # TerraformDevKit uses this path as the base from where
  # all operations are run.
  ROOT_PATH = File.dirname(File.expand_path(__FILE__))
  spec = Gem::Specification.find_by_name 'TerraformDevKit'
  load "#{spec.gem_dir}/tasks/devkit.rake"

  # Optional: Use RSpec to run tests.
  begin
    require 'rspec/core/rake_task'
    RSpec::Core::RakeTask.new(:spec)
  rescue LoadError
    raise 'Rspec not found'
  end

  # Required: Add a hook into TerraformDevKit to 
  # run tests for your module. 
  task :custom_test, [:env] => :spec
end
```

The `custom_test` task is a hook in TerraformDevKit that is called once all the infrastructure is created. You can see a full list of useful hooks in TerraformDevKit [here](https://github.com/vistaprint/TerraformDevKit#tasks-and-hooks)

Create `test/<my_module>/config/config-dev.yml` that contains:

```yml
terraform-version: 0.11.0
project-name: my module tests
aws:
  profile: <profile>
  region: <region>

```

This configuration determines where Terraform will create the infrastructure during test execution. 

Finally to create your infrastructure under test place a `main.tf.mustache` file in `test/<my_module>`. This is the file TerraformDevKit will use to create you infrastructure. 

```hcl
provider "aws" {
  # Use the profile specified in config/config-dev.yml
  profile = "{{Profile}}"
  region  = "us-east-1"
}

resource "aws_s3_bucket" "b" {
  # Use the Environment name as part of the bucket name
  bucket = "{{Environment}}my-tf-test-bucket"
  acl    = "private"

  tags {
    Name        = "My bucket"
    Environment = "Dev"
  }
}
```

## Optional but recommended

[`awspec`](https://github.com/k1LoW/awspec) is a Ruby gem for running `rspec` tests against AWS infrastructure. It eases the pain of running tests against AWS:

```ruby
describe cloudwatch_alarm("www.example.com-5xxErrorRate") do
  it { should exist }
  it { should belong_to_metric('5xxErrorRate').namespace('AWS/CloudFront') }
end
```

To start using `awspec` follow the [Getting Started ](https://github.com/k1LoW/awspec#getting-started) 

# Requirements

* Terraform 0.11.0 or above

# Development

To install this gem locally run `rake install` You should then be able to reference it in your local projects.


