const { Client } = require('ssh2');

const conn = new Client();
const commands = [
  'mkdir -p /opt/sudacards-dashboard',
  'cd /opt/sudacards-dashboard',
  'rm -rf .git *', // Clean directory to ensure fresh clone
  'git clone https://github.com/obayosama25-svg/sudacards249sd.git .',
  'docker compose down',
  'docker compose pull',
  'docker compose up -d --build'
];

conn.on('ready', () => {
  console.log('SSH connection established');
  const execNextCommand = (index) => {
    if (index >= commands.length) {
      console.log('All commands executed successfully!');
      conn.end();
      return;
    }
    const cmd = commands[index];
    console.log(`Executing: ${cmd}`);
    conn.exec(cmd, (err, stream) => {
      if (err) throw err;
      stream.on('close', (code, signal) => {
        console.log(`Command finished with code ${code}`);
        execNextCommand(index + 1);
      }).on('data', (data) => {
        console.log('STDOUT: ' + data);
      }).stderr.on('data', (data) => {
        console.error('STDERR: ' + data);
      });
    });
  };
  execNextCommand(0);
}).on('error', (err) => {
  console.error('SSH connection error:', err);
}).connect({
  host: '2.24.108.101',
  port: 22,
  username: 'root',
  password: 'D1M2X3Dmx@@' // Assuming this is the root password
});
