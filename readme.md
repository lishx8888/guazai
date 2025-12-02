# 静默启动与网络驱动器挂载工具

本项目包含静默启动脚本和相关工具，用于管理网络驱动器挂载及静默执行批处理文件。

## 文件说明

- `静默启动.vbs` - VBScript脚本，用于静默执行批处理文件
- `oec.bat` - 批处理文件，执行网络驱动器挂载等操作

## 使用方法

直接运行 `静默启动.vbs` 脚本，脚本会自动执行相应的批处理文件。

## 关闭系统挂载失败弹窗的方法

如果您希望永久关闭Windows系统关于网络驱动器挂载失败的弹窗提示，可以按照以下步骤修改注册表：

1. 运行 `regedit` 打开注册表编辑器

2. 添加第一个注册表项：
   - 路径：`HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer`
   - 在右侧空白处右键点击，选择「新建」→「DWORD（32位）值」
   - 名称：`NoNetConnectDisconnect`
   - 数值数据：`1`

3. 添加第二个注册表项：
   - 路径：`HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\NetworkProvider`
   - 在右侧空白处右键点击，选择「新建」→「DWORD（32位）值」(如果已存在则直接修改)
   - 名称：`RestoreConnection`
   - 数值数据：`0`

4. 重启计算机后，Windows将不再显示任何网络驱动器相关的对话框。

## 在计划任务中添加静默启动脚本

您可以将静默启动脚本添加到Windows计划任务中，使其在指定时间或系统启动时自动运行。以下是详细的设置步骤：

### 方法一：使用任务计划程序图形界面

1. 按 `Win + R` 键，输入 `taskschd.msc` 并按回车，打开任务计划程序

2. 在右侧面板中，点击「创建基本任务」

3. 输入任务名称（如「静默启动网络驱动器」）和描述，点击「下一步」

4. 选择触发器：
   - 选择「用户登录时」作为触发条件
   点击「下一步」

5. 在「操作」选项中，选择「启动程序」，点击「下一步」

6. 点击「浏览」，找到并选择 `静默启动.vbs` 文件
7. 在「起始于（可选）」字段中，输入脚本所在文件夹的完整路径（例如 `E:\github\guazai`）
8. 点击「下一步」，然后点击「完成」

### 方法二：使用命令行快速创建

您可以使用以下PowerShell命令快速创建计划任务（以用户登录时运行为例）：

```powershell
# 请将路径替换为您的实际路径
$ScriptPath = "E:\github\guazai\静默启动.vbs"
$TaskName = "静默启动网络驱动器"

$Action = New-ScheduledTaskAction -Execute 'wscript.exe' -Argument "\"$ScriptPath\"" -WorkingDirectory "E:\github\guazai"
$Trigger = New-ScheduledTaskTrigger -AtLogOn -User "$env:USERDOMAIN\$env:USERNAME"
$Settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable

Register-ScheduledTask -Action $Action -Trigger $Trigger -TaskName $TaskName -Description "自动静默启动网络驱动器挂载脚本" -Settings $Settings -User "$env:USERDOMAIN\$env:USERNAME" -RunLevel Highest
```

## 注意事项

- 修改注册表前请务必备份注册表
- 注册表修改可能会影响系统行为，请谨慎操作
- 修改后需要重启计算机才能生效
- 在设置计划任务时，建议设置为使用最高权限运行，以确保脚本能够正常访问网络驱动器
- 如果需要修改计划任务的设置，可以在任务计划程序中找到并右键点击任务，选择「属性」进行修改