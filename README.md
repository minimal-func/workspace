# Workspace - Personal productivity application

[![Deploy](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy?template=https://github.com/ildarsafin/myreflections)

Workspace is webapp which allows you to write your thoughts and track your energy levels and rate your day.

Features:
---------
- Write your reflections
- Measure your confidence and energy levels
- Write your biggest challenges
- Write about your learned lessons
- Track your progress and levels
- Your one main goal with countdown!


![Screenshot](/app/assets/images/dashboard_page.png)


![Screenshot](/app/assets/images/plot_energy_level.png)

Roadmap:
---------
- Add endless scrolling (pagination) for reports
- Add CSV export of your data
- Add searching through all content

System Dependencies
-------------------

- Ruby >= 3.2.0 (install with [rbenv](https://github.com/sstephenson/rbenv))
- Rubygems
- Bundler (`gem install bundler`)
- PostgreSQL
- Node.js >= 18.17.1
- Yarn >= 1.22.19

Development Setup
----------------

To start the development server:

```bash
# Install dependencies
bundle install
yarn install

# Start the development server
bin/dev
```

This will start both the Rails server and the esbuild watcher.

JavaScript Bundling
------------------

This project uses esbuild for JavaScript bundling. The main entry point is `app/javascript/packs/application.js`.

To build the JavaScript files:

```bash
yarn build
```

To watch for changes and rebuild automatically:

```bash
yarn build --watch
```

Guidelines
----------
- Pull requests are welcome! If you aren't able to contribute code please open an issue on Github.
- Write specs
- Develop features on dedicated feature branches, feel free to open a PR while it's still WIP
- Please adhere to the [Thoughtbot ruby styleguide](https://github.com/thoughtbot/guides/tree/master/style#ruby)
- All code and commit messages should be in English

License
-------
MyReflections is distributed under the MIT license.
