# Dependabot Pub Runner

A GitHub Action using a Dart Pub ecosystem [Dependabot](https://github.com/dependabot/dependabot-core) gem to create dependency update pull requests.

## About

The runner is work in progress and is using this fork: https://github.com/simpleclub-extended/dependabot-core/tree/project/pub-dart

The runner is a modified version of the [dependabot-script](https://github.com/dependabot/dependabot-script) update script.

## Related work

@JohannSchramm has also made amazing work on a Dependabot Pub integration.  
He uses a different approach and is integrating directly with the Pub API while this integrations heavily utilizes the official Dart Pub CLI.

This runner is copied from https://github.com/JohannSchramm/dependabot-pub-runner.

You can find his implementation here: https://github.com/JohannSchramm/dependabot-core/tree/wip/pub

## Inputs

| Name      | Description                                          | Default           |
| --------- | ---------------------------------------------------- | ----------------- |
| `token`   | Persornal access token used to modify the repository | github.token      |
| `project` | The reposiory you want to create pull requests for   | github.repository |
| `path`    | The path of the pubspec.yaml                         | '/'               |

## Example Workflow

```
name: Dependabot Pub

on:
  schedule:
    - cron: '0 6 * * *'

jobs:
  pub:
    name: Dependabot Pub
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Update
        uses: IchordeDionysos/dependabot-pub-runner@main
        with:
          path: /frontend
```

See [dependabot-pub-example](https://github.com/IchordeDionysos/pub_examples) for working example pull requests.
