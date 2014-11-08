Package.describe({
  name: 'ccorcos:swipe',
  summary: ' /* Fill me in! */ ',
  version: '1.0.0',
  git: ' /* Fill me in! */ '
});

Package.onUse(function(api) {
  api.versionsFrom('1.0');
  api.addFiles('ccorcos:swipe.js');
});

Package.onTest(function(api) {
  api.use('tinytest');
  api.use('ccorcos:swipe');
  api.addFiles('ccorcos:swipe-tests.js');
});
