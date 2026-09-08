using System;
using Avalonia;
using Avalonia.Controls;
using Avalonia.Media;
using Avalonia.Styling;
using Avalonia.Themes.Fluent;
using Avalonia.Controls.ApplicationLifetimes;

namespace SwapProject;

// 1. Класс приложения
public class App : Application
{
    public override void Initialize()
    {
        Styles.Add(new FluentTheme());
        RequestedThemeVariant = ThemeVariant.Dark;
    }

    public override void OnFrameworkInitializationCompleted()
    {
        if (ApplicationLifetime is IClassicDesktopStyleApplicationLifetime desktop)
        {
            desktop.MainWindow = new SwapWindow();
        }
        base.OnFrameworkInitializationCompleted();
    }
}

// 2. Класс окна
public partial class SwapWindow : Window
{
    public SwapWindow()
    {
        Title = "Второй проект - Обмен";
        Width = 400; 
        Height = 300;
        Background = SolidColorBrush.Parse("#2c3e50");
        CanResize = false;
        WindowStartupLocation = WindowStartupLocation.CenterScreen;

        var canvas = new Canvas();

        var edit1 = new TextBox { Width = 150, Watermark = "Текст 1" };
        var edit2 = new TextBox { Width = 150, Watermark = "Текст 2" };
        Canvas.SetLeft(edit1, 30); Canvas.SetTop(edit1, 60);
        Canvas.SetLeft(edit2, 220); Canvas.SetTop(edit2, 60);

        var label1 = new TextBlock { Text = "Первое поле:", Foreground = Brushes.White };
        var label2 = new TextBlock { Text = "Второе поле:", Foreground = Brushes.White };
        Canvas.SetLeft(label1, 30); Canvas.SetTop(label1, 35);
        Canvas.SetLeft(label2, 220); Canvas.SetTop(label2, 35);

        var swapButton = new Button { 
            Content = "Обменять", Width = 120, Height = 40,
            Background = Brushes.SeaGreen, Foreground = Brushes.White
        };
        Canvas.SetLeft(swapButton, 140); Canvas.SetTop(swapButton, 130);

        swapButton.Click += (s, e) => {
            string temp = edit1.Text;
            edit1.Text = edit2.Text;
            edit2.Text = temp;
        };

        var exitButton = new Button { Content = "Выход", Width = 80 };
        Canvas.SetLeft(exitButton, 160); Canvas.SetTop(exitButton, 230);
        exitButton.Click += (s, e) => Close();

        canvas.Children.Add(edit1);
        canvas.Children.Add(edit2);
        canvas.Children.Add(label1);
        canvas.Children.Add(label2);
        canvas.Children.Add(swapButton);
        canvas.Children.Add(exitButton);

        Content = canvas;
    } 
} 

// 3. Точка входа
class Program
{
    [STAThread]
    public static void Main(string[] args) => BuildAvaloniaApp()
        .StartWithClassicDesktopLifetime(args);

    public static AppBuilder BuildAvaloniaApp()
        => AppBuilder.Configure<App>()
            .UsePlatformDetect()
            .LogToTrace();
} 