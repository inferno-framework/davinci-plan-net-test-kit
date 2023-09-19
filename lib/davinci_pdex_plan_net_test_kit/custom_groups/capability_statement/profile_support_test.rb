module DaVinciPDEXPlanNetTestKit
  class ProfileSupportTest < Inferno::Test
    id :davinci_pdex_plan_net_profile_support
    title 'Capability Statement lists support for required Plan Net Profiles'
    description %(
      The Plan Net Implementation Guide states:

      ```
      The Plan Net Server SHALL:
      1. Support all profiles defined in this Implementation Guide.

      In order to support USCDI, servers must support all USCDI resources.
      ```
    )
    uses_request :capability_statement

    run do
      assert_resource_type(:capability_statement)
      capability_statement = resource

      supported_resources =
        capability_statement.rest
          &.each_with_object([]) do |rest, resources|
            rest.resource.each { |resource| resources << resource.type }
          end.uniq


      if config.options[:required_resources].present?
        missing_resources = config.options[:required_resources] - supported_resources

        missing_resource_list =
          missing_resources
          .map { |resource| "`#{resource}`" }
          .join(', ')

        assert missing_resources.empty?,
               "The CapabilityStatement did not list support for the following resources: #{missing_resource_list}"
      end
    end
  end
end
