module DaVinciPlanNetTestKit
  class ProfileSupportTest < Inferno::Test
    id :davinci_plan_net_profile_support
    title 'Capability Statement lists support for required Plan Net Profiles'
    description %(
      The Plan Net Implementation Guide states:

      ```
      The Plan Net Server SHALL:
      1. Support all profiles defined in this Implementation Guide.
      ```
    )

    verifies_requirements 'hl7.fhir.us.davinci-pdex-plan-net_1.1.0@12'

    uses_request :capability_statement

    run do
      assert_resource_type(:capability_statement)
      capability_statement = resource

      supported_profiles =
        capability_statement.rest
          &.each_with_object([]) do |rest, profiles|
            rest.resource.each { |resource| profiles.concat(resource.supportedProfile) }
          end.uniq

      davinci_plan_net_profiles = config.options[:davinci_plan_net_profiles]

      missing_profiles = davinci_plan_net_profiles - supported_profiles

      missing_profiles_list =
        missing_profiles
          .map { |resource| "`#{resource}`" }
          .join(', ')

      assert missing_profiles.empty?,
        "The CapabilityStatement did not list support for the following profiles: #{missing_profiles_list}"
    end
  end
end
