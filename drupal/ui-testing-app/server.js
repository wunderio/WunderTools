const express = require('express');
const path = require('path');
const listDirectories = require('list-directories');
const fs = require('fs');
const shortid = require('shortid');
const nodeCmd = require('node-cmd');

const app = express();
const port = process.env.PORT || 5000;
const testsLocation = '../tests/';

app.get('/api/list/test-types', (req, res) => {
  listDirectories(testsLocation).then(absolutePaths => {
    const dirs = [];
    for (let absolutePath of absolutePaths) {
      const dirName = path.basename(absolutePath);

      if (!dirName.startsWith('_')) dirs.push(dirName);
    }

    res.send({ express: dirs });
  });
});

app.get('/api/list/tests-by-type/:type', (req, res) => {
  const testType = req.params.type;
  const data = [];

  fs.readdir(testsLocation + '/' + testType, (err, filenames) => {
    if (err !== null) return;

    for (let filename of filenames) {
      if (!filename.startsWith('_')) {
        data.push({
          id: shortid.generate(),
          type: testType,
          name: filename,
          filename: filename,
          //path
          lastStatus: null,
          isChecked: false,
          log: []
        });
      }
    }

    res.send({ express: data });
  });
});

app.get('/api/run/test/:testType/:testTitle', (req, res) => {
  const { testType, testTitle } = req.params;
  const commands = [
    'cd ../',
    `vendor/bin/codecept run ${testType} ${testTitle} --no-ansi`,
  ];
  const command = commands.join(' && ');

  nodeCmd.get(command, (error, data, stderr) => {
    if (!error) {
      res.send({
        express: data,
        debug: { command },
      });
    } else {
      console.error('Error', error);
      res.send({ error, stderr });
    }
  });
});

app.listen(port, () => console.log(`Listening on port ${port}`));