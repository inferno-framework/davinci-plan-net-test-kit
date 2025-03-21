# 0.12.0
##Breaking Change
This release updates the Da Vinci Plan Net Test Kit to use AuthInfo rather than
OAuthCredentials for storing auth information. As a result of this change, any
test kits which rely on this test kit will need to be updated to use AuthInfo
rather than OAuthCredentials inputs.

## What's Changed
* FI-3746: Use AuthInfo by @Jammjammjamm in https://github.com/inferno-framework/davinci-plan-net-test-kit/pull/17

# 0.11.1
* Add missing require by @Jammjammjamm in https://github.com/inferno-framework/davinci-plan-net-test-kit/pull/16

# 0.11.0
## Breaking Changes:
- **Ruby Version Update:** Upgraded Ruby to `3.3.6`.
- **Inferno Core Update:** Bumped to version `0.6`.
- **Gemspec Updates:**
  - Switched to `git` for specifying files.
  - Added `presets` to the gem package.
  - Updated any test kit dependencies
- **Test Kit Metadata:** Implemented Test Kit metadata for Inferno Platform.
- **Environment Updates:** Updated Ruby version in the Dockerfile and GitHub Actions workflow.

* FI-3648 Add metadata and platform deployable spec by @Shaumik-Ashraf in https://github.com/inferno-framework/davinci-plan-net-test-kit/pull/13

# 0.10.1
* Dependency Updates 2024-07-03 by @Jammjammjamm in https://github.com/inferno-framework/davinci-plan-net-test-kit/pull/10
* FI-3380 - Duplicate id fix by @karlnaden in https://github.com/inferno-framework/davinci-plan-net-test-kit/pull/11

# 0.10.0
* dependency updates 2024-06-05 by @Jammjammjamm in 
  https://github.com/inferno-framework/davinci-plan-net-test-kit/pull/8
* bump core version in gemspec by @dehall in
  https://github.com/inferno-framework/davinci-plan-net-test-kit/pull/7
* migrated to HL7 validator wrapper by @dehall in
  https://github.com/inferno-framework/davinci-plan-net-test-kit/pull/6
* dependency updates 2024-04-05 by @Jammjammjamm in
  https://github.com/inferno-framework/davinci-plan-net-test-kit/pull/5
* dependency updates 2024-03-19 by @Jammjammjamm in 
  https://github.com/inferno-framework/davinci-plan-net-test-kit/pull/4

# 0.9.1
* disclaimer on reference implementation preset not passing by @karlnaden in
  https://github.com/inferno-framework/davinci-plan-net-test-kit/pull/1
* add IG link to lower right by @karlnaden in
  https://github.com/inferno-framework/davinci-plan-net-test-kit/pull/2

# 0.9.0

* Initial public release.
