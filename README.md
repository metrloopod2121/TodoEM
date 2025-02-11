# TodoEM

### В приложении два экрана (модуля):
- Экран со списком задач (TodoList)
- Экран с добавлением/редактированием задачи (TaskDetails)

Модули тесно связаны между собой, поэтому **Presenter**, **Interactor**, **ViewState** - у них общие сущности. Для экрана добавления/редактрования задачи добавлена только индивидуальное View.

**ViewState** используется как промежуточный слой между **Presenter** и **View**. Это нужно чтобы сделать код логически более понятным. Также такой подход позволит сохранить декларативную "природу" SwiftUI - **Presenter** не будет обращаться к **View** напрямую, а будет изменять наблюдаемые переменные внутри **ViewState**, благодаря чему **View** будет "магически" обновляться. Также мы изолируем **View** от любой бизнес-логики и оно будет отвечать только за отображение. 

Для фреймворка **CoreData** выделена отдельная папка, с необходимыми файлами.

Для загрузки, редактирования, добавления и удаления задач используем фреймворк **GCD** чтобы обрабатывать события в фоновом потоке.

Сущность **Router** опущена, в этом проекте её использование только засоряет код и делает его трудно читаемым. 
