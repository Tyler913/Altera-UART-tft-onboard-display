# Altera UART TFT 板载显示器项目 / Altera UART TFT Onboard Display Project

[中文](#中文说明) | [English](#english-description)

---

## English Description

### Project Overview

This is an Altera/Intel FPGA-based UART to TFT display project that receives text data via serial port and displays it in real-time on a TFT screen. The project supports adjustable font sizes, real-time text rendering, and simple command controls.

### Key Features

- 🔗 **UART Serial Communication**: Supports 9600 baud rate serial data reception
- 🖥️ **TFT Display Control**: 480×272 resolution TFT screen driver
- 🔤 **Character Rendering Engine**: 8×16 pixel font supporting English letters, numbers, and special characters
- 📏 **Adjustable Font Size**: 4 font size levels (0-3)
- ⚡ **Real-time Display**: Received text is immediately displayed on screen
- 🎮 **Command Control**:
  - `+`: Increase font size
  - `-`: Decrease font size
  - `#`: Clear screen

### Hardware Requirements

- **FPGA Model**: Cyclone IV series (or compatible)
- **System Clock**: 50 MHz input clock
- **TFT Display**: 480×272 resolution, 16-bit RGB565 interface
- **Serial Interface**: Standard UART, 9600 baud rate
- **PLL Clock**: Internal 9 MHz TFT driving clock generation

### Project Structure

```
Altera-UART-tft-onboard-display/
├── RTL/                          # Verilog source code
│   ├── top_file.v                # Top-level module
│   ├── UART_RX.v                 # UART receiver module
│   ├── Name_Manipulation.v       # Text processing module
│   ├── Glyph_Renderer.v          # Character rendering module
│   └── tft_control.v             # TFT display control module
├── Quartus_Project/              # Quartus Prime project files
│   ├── IP_Cores/                 # IP core files
│   │   ├── PLL/                  # PLL clock generator
│   │   ├── PLL_New/              # New PLL (9MHz)
│   │   └── ROM_1-PORT/           # Single-port ROM
│   └── ROM_File/                 # Font ROM data
│       └── font8x16_rom.mif      # 8×16 font data file
└── README.md                     # Project documentation
```

### Module Descriptions

#### 1. `top_file.v` - Top-level Module
- Connects all sub-modules
- Instantiates UART, text processing, character rendering, and TFT control modules
- Manages clock and reset signals

#### 2. `UART_RX.v` - UART Receiver Module
- Serial data reception supporting 9600 baud rate
- Parameterized design with configurable baud rate and clock frequency
- Provides reception complete flag and data output

#### 3. `Name_Manipulation.v` - Text Processing Module
- Manages received text data (maximum 10 characters)
- Handles font size control commands (+/-)
- Processes clear screen command (#)
- Generates text ready flag

#### 4. `Glyph_Renderer.v` - Character Rendering Module
- Reads character bitmap data from ROM
- Supports scalable font rendering (1× to 4×)
- Implements pixel-level character drawing
- Supports 55 characters: space, +, -, A-Z, a-z

#### 5. `tft_control.v` - TFT Display Control Module
- Generates TFT display timing signals
- Manages horizontal/vertical sync signals
- Controls data enable and backlight signals
- Outputs RGB565 format image data

### Supported Character Set

The project supports the following 55 characters:
- **Space**: ` `
- **Operators**: `+` `-`
- **Uppercase letters**: `A-Z`
- **Lowercase letters**: `a-z`

### Technical Specifications

| Parameter | Specification |
|-----------|---------------|
| Maximum text length | 10 characters |
| Font specification | 8×16 pixel bitmap |
| Font size levels | 4 levels (0-3) |
| Display resolution | 480×272 pixels |
| Color depth | 16-bit RGB565 |
| UART baud rate | 9600 bps |
| System clock | 50 MHz |
| TFT clock | 9 MHz |

### Usage Instructions

#### 1. Project Compilation
1. Open `Quartus_Project/UART_Onboard_Display.qpf` in Quartus Prime
2. Ensure all IP cores are properly generated
3. Compile the project and generate .sof file
4. Download the program to FPGA

#### 2. Hardware Connections
- Connect TFT display to corresponding GPIO pins
- Connect UART serial port to PC or other device
- Provide 50 MHz system clock

#### 3. Serial Port Operation
1. Configure serial tool: 9600 baud rate, 8 data bits, 1 stop bit, no parity
2. Send text characters for real-time display on screen
3. Use control commands:
   - Send `+` to increase font size
   - Send `-` to decrease font size
   - Send `#` to clear screen

### Development Environment

- **FPGA Development Tool**: Intel Quartus Prime
- **Simulation Tool**: ModelSim (optional)
- **Hardware Debug**: SignalTap II Logic Analyzer (optional)
- **Version Control**: Git

---

## License

This project is open source. Please refer to the license file for specific terms.

## Contributing

Contributions are welcome! Please feel free to submit issues and pull requests.

## Contact

If you have any questions or suggestions, please create an issue in the GitHub repository.


## 中文说明

### 项目简介

这是一个基于 Altera/Intel FPGA 的 UART 到 TFT 显示器项目，实现了通过串口接收文本数据并在 TFT 屏幕上实时显示的功能。项目支持可调字体大小、实时文本渲染和简单的命令控制。

### 主要功能特性

- 🔗 **UART 串口通信**：支持 9600 波特率串口数据接收
- 🖥️ **TFT 显示控制**：480×272 分辨率 TFT 屏幕驱动
- 🔤 **字符渲染引擎**：8×16 像素字体，支持英文字母、数字和特殊字符
- 📏 **可调字体大小**：4 个字体大小级别（0-3）
- ⚡ **实时显示**：接收到的文本立即显示在屏幕上
- 🎮 **命令控制**：
  - `+`：增大字体
  - `-`：减小字体  
  - `#`：清屏

### 硬件要求

- **FPGA 型号**：Cyclone IV 系列（或兼容型号）
- **系统时钟**：50 MHz 输入时钟
- **TFT 显示器**：480×272 分辨率，16位 RGB565 接口
- **串口接口**：标准 UART，9600 波特率
- **PLL 时钟**：内部生成 9 MHz TFT 驱动时钟

### 项目结构

```
Altera-UART-tft-onboard-display/
├── RTL/                          # Verilog 源代码
│   ├── top_file.v                # 顶层模块
│   ├── UART_RX.v                 # UART 接收模块
│   ├── Name_Manipulation.v       # 文本处理模块
│   ├── Glyph_Renderer.v          # 字符渲染模块
│   └── tft_control.v             # TFT 显示控制模块
├── Quartus_Project/              # Quartus Prime 项目文件
│   ├── IP_Cores/                 # IP 核心文件
│   │   ├── PLL/                  # PLL 时钟生成器
│   │   ├── PLL_New/              # 新版 PLL（9MHz）
│   │   └── ROM_1-PORT/           # 单端口 ROM
│   └── ROM_File/                 # 字体 ROM 数据
│       └── font8x16_rom.mif      # 8×16 字体数据文件
└── README.md                     # 项目说明文档
```

### 模块功能说明

#### 1. `top_file.v` - 顶层模块
- 连接所有子模块
- 实例化 UART、文本处理、字符渲染和 TFT 控制模块
- 管理时钟和复位信号

#### 2. `UART_RX.v` - UART 接收模块
- 串口数据接收，支持 9600 波特率
- 参数化设计，可配置波特率和时钟频率
- 提供接收完成标志和数据输出

#### 3. `Name_Manipulation.v` - 文本处理模块
- 管理接收到的文本数据（最大10个字符）
- 处理字体大小控制命令（+/-）
- 处理清屏命令（#）
- 生成文本就绪标志

#### 4. `Glyph_Renderer.v` - 字符渲染模块
- 从 ROM 中读取字符位图数据
- 支持可缩放字体渲染（1×到4×）
- 实现像素级字符绘制
- 支持55个字符：空格、+、-、A-Z、a-z

#### 5. `tft_control.v` - TFT 显示控制模块
- 生成 TFT 显示时序信号
- 管理水平/垂直同步信号
- 控制数据使能和背光信号
- 输出 RGB565 格式图像数据

### 支持的字符集

项目支持以下55个字符：
- **空格**：` `
- **运算符**：`+` `-`
- **大写字母**：`A-Z`
- **小写字母**：`a-z`

### 技术规格

| 参数 | 规格 |
|------|------|
| 最大文本长度 | 10个字符 |
| 字体规格 | 8×16像素位图 |
| 字体大小级别 | 4级（0-3） |
| 显示分辨率 | 480×272像素 |
| 颜色深度 | 16位 RGB565 |
| UART波特率 | 9600 bps |
| 系统时钟 | 50 MHz |
| TFT时钟 | 9 MHz |

### 使用方法

#### 1. 项目编译
1. 使用 Quartus Prime 打开 `Quartus_Project/UART_Onboard_Display.qpf`
2. 确保所有 IP 核心已正确生成
3. 编译项目并生成 .sof 文件
4. 将程序下载到 FPGA

#### 2. 硬件连接
- 连接 TFT 显示器到对应的 GPIO 引脚
- 连接 UART 串口到 PC 或其他设备
- 提供 50 MHz 系统时钟

#### 3. 串口操作
1. 配置串口工具：9600波特率，8数据位，1停止位，无校验
2. 发送文本字符，将实时显示在屏幕上
3. 使用控制命令：
   - 发送 `+` 增大字体
   - 发送 `-` 减小字体
   - 发送 `#` 清屏

### 开发环境

- **FPGA开发工具**：Intel Quartus Prime
- **仿真工具**：ModelSim（可选）
- **硬件调试**：SignalTap II Logic Analyzer（可选）
- **版本控制**：Git
