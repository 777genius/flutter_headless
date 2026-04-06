# styled_widget

**Method chaining для стилизации виджетов**

## Информация

| | |
|---|---|
| **Пакет** | [pub.dev/packages/styled_widget](https://pub.dev/packages/styled_widget) |
| **GitHub** | [github.com/ReinBentdal/styled_widget](https://github.com/ReinBentdal/styled_widget) |
| **Версия** | 0.4.1 |
| **Автор** | Rein Gundersen Bentdal |
| **Лицензия** | MIT |
| **Обновление** | 3 года назад (не активен) |
| **Лайки** | 905 |
| **Загрузки** | 7.43k |

## Концепция

> "Simplifying widget style in Flutter."

CSS-подобный подход через method chaining. Вместо вложенных виджетов — цепочка методов.

## Проблема которую решает

Стандартный Flutter код с глубокой вложенностью:

```dart
// Без styled_widget — 30+ строк, трудно читать
DecoratedBox(
  decoration: BoxDecoration(
    color: Color(0xffEBECF1),
  ),
  child: Align(
    alignment: Alignment.center,
    child: Card(
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Color(0xffE8F2F7),
            shape: BoxShape.circle,
          ),
          child: Padding(
            padding: EdgeInsets.all(15),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Color(0xff7AC1E7),
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Icon(Icons.home, color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    ),
  ),
)
```

## Со styled_widget

```dart
// Bottom-up: от внутреннего к внешнему
Icon(Icons.home, color: Colors.white)
  .padding(all: 10)
  .decorated(color: Color(0xff7AC1E7), shape: BoxShape.circle)
  .padding(all: 15)
  .decorated(color: Color(0xffE8F2F7), shape: BoxShape.circle)
  .padding(all: 20)
  .card(
    elevation: 10,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
  )
  .alignment(Alignment.center)
  .backgroundColor(Color(0xffEBECF1));
```

## Доступные методы

### Layout
```dart
widget
  .padding(all: 16)
  .padding(horizontal: 8, vertical: 4)
  .padding(left: 10, top: 5)
  .margin(all: 8)
  .alignment(Alignment.center)
  .center()
  .width(100)
  .height(50)
  .constrained(minWidth: 50, maxWidth: 200)
  .expanded()
  .flexible()
  .positioned(top: 0, left: 0)  // для Stack
```

### Decoration
```dart
widget
  .backgroundColor(Colors.blue)
  .decorated(
    color: Colors.white,
    borderRadius: BorderRadius.circular(8),
    border: Border.all(color: Colors.grey),
    boxShadow: [BoxShadow(...)],
  )
  .borderRadius(all: 8)
  .border(all: 1, color: Colors.grey)
  .boxShadow(color: Colors.black26, blurRadius: 10)
  .elevation(4)
  .clipRRect(all: 8)
  .clipOval()
```

### Transform
```dart
widget
  .rotate(angle: 0.5)
  .scale(all: 1.2)
  .scale(x: 1.5, y: 0.8)
  .translate(offset: Offset(10, 20))
  .transform(matrix: Matrix4.identity())
```

### Gestures
```dart
widget
  .gestures(
    onTap: () => print('tap'),
    onLongPress: () => print('long press'),
    onDoubleTap: () => print('double tap'),
  )
  .ripple()  // InkWell
  .opacity(0.5)
```

### Cards & Material
```dart
widget
  .card(elevation: 4)
  .material(elevation: 2, borderRadius: BorderRadius.circular(8))
```

### Scrolling
```dart
widget
  .scrollable()
  .scrollable(controller: _controller, physics: BouncingScrollPhysics())
```

### Semantics
```dart
widget
  .semanticsLabel('Button')
```

## Анимации

```dart
// Animated версии
widget
  .animate(Duration(milliseconds: 300), Curves.easeOut)
  .padding(all: isExpanded ? 20 : 10)
  .backgroundColor(isActive ? Colors.blue : Colors.grey)
```

## Пример: Кнопка

```dart
class StyledButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final bool isPressed;

  @override
  Widget build(BuildContext context) {
    return Text(text)
      .textColor(Colors.white)
      .fontSize(16)
      .fontWeight(FontWeight.bold)
      .padding(horizontal: 24, vertical: 12)
      .backgroundColor(isPressed ? Colors.blue.shade700 : Colors.blue)
      .borderRadius(all: 8)
      .elevation(isPressed ? 2 : 4)
      .animate(Duration(milliseconds: 150), Curves.easeOut)
      .gestures(onTap: onTap);
  }
}
```

## Пример: Карточка профиля

```dart
Widget profileCard(User user) {
  return <Widget>[
    CircleAvatar(backgroundImage: NetworkImage(user.avatar))
      .width(80)
      .height(80),
    SizedBox(height: 16),
    Text(user.name)
      .fontSize(20)
      .fontWeight(FontWeight.bold),
    Text(user.email)
      .fontSize(14)
      .textColor(Colors.grey),
  ]
    .toColumn(mainAxisSize: MainAxisSize.min)
    .padding(all: 24)
    .card(elevation: 4)
    .width(300);
}
```

## Расширение списков

```dart
// Список виджетов в Column/Row
[Widget1(), Widget2(), Widget3()]
  .toColumn()
  .toRow()
  .toStack()
  .toWrap()
```

## Плюсы

- ✅ **Читаемость** — flat structure вместо вложенности
- ✅ **CSS-like** — привычно для веб-разработчиков
- ✅ **Bottom-up** — от контента к обёртке
- ✅ **Анимации** — встроенные
- ✅ **Цепочки** — легко модифицировать

## Минусы

- ❌ **НЕ headless** — только styling sugar
- ❌ **Не активен** — 3 года без обновлений
- ❌ **Runtime overhead** — много мелких виджетов
- ❌ **Не type-safe** — все параметры опциональны
- ❌ **Нет тем** — цвета хардкодятся
- ❌ **Нет вариантов**

## Что можно взять

1. **Идея method chaining** — для builder API
2. **Bottom-up подход** — от контента к обёртке

## Сравнение с нашим подходом

| Аспект | styled_widget | Headless |
|--------|---------------|------------|
| Headless | ❌ | ✅ |
| Подход | Method chaining | Builder + Theme |
| Theming | ❌ | ✅ |
| Варианты | ❌ | ✅ sealed |
| Type-safety | ❌ | ✅ |
| Активность | ❌ мёртв | ✅ |

## Оценка

| Критерий | Оценка |
|----------|:------:|
| Headless | 2 |
| Type-safety | 4 |
| Theming | 2 |
| Документация | 6 |
| Готовность | 5 |
| **Итого** | **3.8** |
