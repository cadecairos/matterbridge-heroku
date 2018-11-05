# Matterbridge-Heroku

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy)

An inline buildpack for hosting Matterbridge on Heroku.

[**Heroku**][heroku] is a platform for easily deploying applications.

A [**buildpack**][buildpacks] provides framework and runtime support for
apps running on platforms like Heroku.

An [**_inline_ buildpack**][inline-buildpacks] is a special buildpack
that includes code for both the app and the buildpack that _runs_ the
app.

[**Matterbridge**][matterbridge] is a simple _bridge_ that can relay
messages between a number of different chat services, essentially
connecting separate chat tools.

   [heroku]: https://www.heroku.com/what
   [buildpacks]: https://docs.cloudfoundry.org/buildpacks/
   [inline-buildpacks]: https://github.com/kr/heroku-buildpack-inline#readme
   [matterbridge]: https://github.com/42wim/matterbridge#readme

This repo includes [a custom config file][config] specific to a sample
implementation, but this is intended to be modified in your own fork.

## Configuration

Configuration happens via environment variables and a configuration
template file.

### Environment: Buildpack

- `MATTERBRIDGE_VERSION` Required. Use a [matterbridge git tag][git-tags].
- `MATTERBRIDGE_URL` Optional. Use this to download the binary from a
  custom url instead of the tagged release from the official GitHub
repo.  (Setting this makes `MATTERBRIDGE_VERSION` ignored.)
    * With caution, you may want to use the [latest nightly matterbridge
      build](https://bintray.com/42wim/nightly/Matterbridge/_latestVersion)
      while waiting on the next official release.

### Environment: Matterbridge

Matterbridge has some configuration of its own, which is mostly
documented upstream. For starters, we'll review the most important
aspects:

* `DEBUG`. Set to "1" to log all message events across bridges.

Matterbridge uses Viper, and so each value in the TOML configuration can
be set by envvar.

Basically, here are the rules:

- Each config envvar is prefixed with `MATTERBRIDGE_`.
- Each nested level of config object is separated by an underscore `_`.
- Any dash in a config key is converted to an underscore `_`.

So for example, with this in your TOML config:

```toml
[slack.my-team]
Token="xoxp-xxxxxxxxxxxxxxxxxxxxxxxxxxx"
```

You could instead set an environment variable for
`MATTERBRIDGE_SLACK_MY_TEAM_TOKEN` and leave that key out of in the
configuration file template.

### Template: Matterbridge

* Edit channel bridge config via [`config/config-heroku-template.toml`][config].

## Related Projects

- [**Matterbridge Config Viewer.**][viewer] Render a Matterbridge config
  file as a simple read-only web app.
- [**Matterbridge Auto-Config.**][autoconfig] Generate a config file
  based on Slack channel naming conventions.

<!-- Links -->
   [git-tags]: https://github.com/42wim/matterbridge/tags
   [config]: config/config-heroku-template.toml
   [viewer]: https://github.com/patcon/matterbridge-heroku-viewer
   [autoconfig]: https://github.com/patcon/matterbridge-autoconfig/
