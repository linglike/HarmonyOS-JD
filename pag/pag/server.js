const WebSocket = require('ws');

// 创建WebSocket服务器实例，监听在8080端口，可按需修改端口号
const wss = new WebSocket.Server({ port: 8080 });

// 当有客户端连接时触发的事件
wss.on('connection', (ws) => {
  console.log('有客户端连接成功');
  // 当收到客户端发送的消息时触发的事件
  ws.on('message', (message) => {
    console.log('收到客户端消息:', message.toString());
    // 这里简单将消息原样返回给客户端，实际可按需做更复杂处理
    ws.send('服务器已收到你的消息大苏打:' + message.toString());
  });
  // 向刚连接的客户端发送欢迎消息
  ws.send('欢迎连接到本WebSocket服务器');
});
