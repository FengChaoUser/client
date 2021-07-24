// Modules to control application life and create native browser window
const electron = require('electron');
const {app, BrowserWindow, ipcMain, Menu, MenuItem, globalShortcut} = require('electron');
const autoUpdater = require("electron-updater").autoUpdater; //引入 autoUpdater
const request = require('request')
const fs = require('fs');
const path = require('path')
// const renderProcessApi = path.join(__dirname, 'inject.js')

let mainWindow, webContents
if (require('electron-squirrel-startup')) return;
// Keep a global reference of the window object, if you don't, the window will
// be closed automatically when the JavaScript object is garbage collected.


function createWindow() {
  console.log('主进程');
  // Create the browser window.
  Menu.setApplicationMenu(null)
  mainWindow = new BrowserWindow({
    width: 800,
    height: 600,
    icon: 'icon.ico',
    fullscreen: false,
    frame: true,
    webPreferences: {
      nodeIntegration: true,
      // preload: renderProcessApi
    },
    backgroundColor: '#fff',
    show: false // 先隐藏
  })

  // and load the index.html of the app.
  // mainWindow.loadFile('index.html');
  mainWindow.loadURL('https://www.baidu.com/');
  mainWindow.on('ready-to-show', function () {
    mainWindow.show() // 初始化后再显示
  })
  webContents = mainWindow.webContents;
  // mainWindow.openDevTools();
  globalShortcut.register('F5', () => {
    webContents.reloadIgnoringCache();
  });
  // Open the DevTools.
  globalShortcut.register('ctrl+F12', () => {
    mainWindow.webContents.openDevTools()
  });
  

  // Emitted when the window is closed.
  mainWindow.on('closed', function () {
    // Dereference the window object, usually you would store windows
    // in an array if your app supports multi windows, this is the time
    // when you should delete the corresponding element.
    mainWindow = null
  });
  ipcMain.on('shrinkApp', () => {
    mainWindow.minimize()
  });
  ipcMain.on('quitApp', () => {
    mainWindow.close();
  });
  ipcMain.on('downloadDoc', (event, arg1, arg2, arg3) => {
    mainWindow.webContents.downloadURL('http://192.168.0.30:8083/ec/capacity/downloadCapacity?studyModel=' + JSON.parse(arg1) + '&courseId=' + JSON.parse(arg2) + '&unitId=' + JSON.parse(arg3));
  });

  // ipcMain.on('sigShowRightClickMenu', (event) => {
  //   // 生成菜单
  //   const menu = new Menu();
  //   menu.append(new MenuItem({
  //     label:'刷新',
  //     click: function() {
  //       webContents.reloadIgnoringCache();
  //     }
  //   }));
  //
  //   const win = BrowserWindow.fromWebContents(event.sender);
  //   menu.popup(win);
  // });
}


// This method will be called when Electron has finished
// initialization and is ready to create browser windows.
// Some APIs can only be used after this event occurs.
const gotTheLock = app.requestSingleInstanceLock();

if (!gotTheLock) {
  app.quit()
} else {
  app.on('second-instance', (event, commandLine, workingDirectory) => {
    // 当运行第二个实例时,将会聚焦到myWindow这个窗口
    if (mainWindow) {
      if (mainWindow.isMinimized()) mainWindow.restore()
      mainWindow.focus()
    }
  })
}
app.on('ready', createWindow);

// Quit when all windows are closed.
app.on('window-all-closed', function () {
  // On OS X it is common for applications and their menu bar
  // to stay active until the user quits explicitly with Cmd + Q
  if (process.platform !== 'darwin') {
    app.quit()
  }
})

app.on('activate', function () {
  // On OS X it's common to re-create a window in the app when the
  // dock icon is clicked and there are no other windows open.
  if (mainWindow === null) {
    createWindow()
  }
});

//  检查更新
!function updateHandle() {
  let message = {
    error: '检查更新出错',
    checking: '正在检查更新……',
    updateAva: '检测到新版本，正在下载……',
    updateNotAva: '现在使用的就是最新版本，不用更新',
  };
  //  x64 http://oss.yydz100.com/app-patch/win64
  const uploadUrl = "http://oss.yydz100.com/app-patch/win64"; // 下载地址，不加后面的**.exe
  autoUpdater.setFeedURL(uploadUrl);
  autoUpdater.on('error', function (error) {
    console.log(autoUpdater.error);
    sendUpdateMessage(message.error)
  });
  autoUpdater.on('checking-for-update', function () {
    sendUpdateMessage(message.checking);
    // const stream = fs.createWriteStream('latest.yml');
    // 'http://oss.yydz100.com/app-patch/latest.yml'
    const currentVersion = app.getVersion();
    // request('http://oss.yydz100.com/app-patch/latest.yml').pipe(stream).on("close", function (err) {
    //   const ymlBuffer = fs.readFileSync('latest.yml')
    //   const remoteVersion = JSON.stringify(ymlBuffer.toString()).split('\\n')[0].split(' ')[1]
    //   sendVersion(remoteVersion, currentVersion);
    // });
    //  x64 http://oss.yydz100.com/app-patch/win64/latest.yml
    request.get('http://oss.yydz100.com/app-patch/win32/latest.yml', (error, response, body) =>{
      if (!error && response.statusCode == 200) {
        // csv = body;
        sendVersion(JSON.stringify(body.toString()).split('\\n')[0].split(' ')[1], currentVersion);
      }
    })
  }); 
  autoUpdater.on('update-available', function (info) {
    sendUpdateMessage(message.updateAva)
  });
  autoUpdater.on('update-not-available', function (info) {
    sendUpdateMessage(message.updateNotAva)
  });

  // 更新下载进度事件
  autoUpdater.on('download-progress', function (progressObj) {
    mainWindow.webContents.send('downloadProgress', progressObj)
  });
  autoUpdater.on('update-downloaded', function (event, releaseNotes, releaseName, releaseDate, updateUrl, quitAndUpdate) {

    ipcMain.on('isUpdateNow', (e, arg) => {
      //some code here to handle event
      autoUpdater.quitAndInstall();
    });

    mainWindow.webContents.send('isUpdateNow')
  });

  ipcMain.on("checkForUpdate", () => {
    //执行自动更新检查
    autoUpdater.checkForUpdates();
  })
}();

// 通过main进程发送事件给renderer进程，提示更新信息
function sendUpdateMessage(text) {
  mainWindow.webContents.send('message', text)
}
function sendVersion(newVersion, lastVersion) {
  mainWindow.webContents.send('getVersion', newVersion, lastVersion)
}

// In this file you can include the rest of your app's specific main process
// code. You can also put them in separate files and require them here.

