//
//  ContentView.swift
//  DragAndDrop
//
//  Created by duverney muriel on 28/07/23.
//

import SwiftUI
import Algorithms
import UniformTypeIdentifiers


struct ContentView: View {

    @State private var toDoTasks: [DeveloperTask] = [MockData.taskOne,MockData.taskTwo,MockData.taskThree]
    @State private var inProgressTasks: [DeveloperTask] = []
    @State private var doneTasks: [DeveloperTask] = []
    
    @State private var  isToDoTargeted = false
    @State private var  isinProgressTasksTargeted = false
    @State private var  isDoneTargeted = false

    var body: some View {
        HStack(spacing: 12) {
            KanbanView(isTargeted: isToDoTargeted, title: "Para Hacer", tasks: toDoTasks)
                .dropDestination(for: DeveloperTask.self) { dropTasks, location in
                    for task in dropTasks{
                        inProgressTasks.removeAll { $0.id == task.id}
                        doneTasks.removeAll { $0.id == task.id}
                    }
                    
                    let totalTaks = toDoTasks + dropTasks
                    toDoTasks = Array(totalTaks.uniqued())
                    
                    return true
                }isTargeted: { isTargeted in
                    isToDoTargeted = isTargeted
                }
            KanbanView(isTargeted: isinProgressTasksTargeted, title: "En proceso", tasks: inProgressTasks)
                .dropDestination(for: DeveloperTask.self) { dropTasks, location in
                    for task in dropTasks{
                        toDoTasks.removeAll { $0.id == task.id}
                        doneTasks.removeAll { $0.id == task.id}
                    }
                    
                    let totalTaks = inProgressTasks + dropTasks
                    inProgressTasks = Array(totalTaks.uniqued())
                    
                    return true
                }isTargeted: { isTargeted in
                    isinProgressTasksTargeted = isTargeted
                }
            KanbanView(isTargeted: isDoneTargeted, title: "Hecho", tasks: doneTasks)
                .dropDestination(for: DeveloperTask.self) { dropTasks, location in
                    for task in dropTasks{
                        toDoTasks.removeAll { $0.id == task.id}
                        inProgressTasks.removeAll { $0.id == task.id}
                    }
                    
                    let totalTaks = doneTasks + dropTasks
                    doneTasks = Array(totalTaks.uniqued())
                    
                    return true
                }isTargeted: { isTargeted in
                    isDoneTargeted = isTargeted
                }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewInterfaceOrientation(.landscapeRight)
    }
}

struct KanbanView: View {
    
    let isTargeted: Bool
    let title: String
    let tasks: [DeveloperTask]

    var body: some View {
        VStack(alignment: .leading) {
            Text(title).font(.footnote.bold())

            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(isTargeted ? .teal.opacity(0.15) : Color(.secondarySystemFill))

                VStack(alignment: .leading, spacing: 12) {
                    ForEach(tasks, id: \.id) { task in
                        Text(task.title)
                            .padding(12)
                            .background(Color(uiColor: .secondarySystemGroupedBackground))
                            .cornerRadius(8)
                            .shadow(radius: 1, x: 1, y: 1)
                            .draggable(task)
                    }

                    Spacer()
                }
                .padding(.vertical)
            }
        }
    }
}


struct DeveloperTask: Codable,Hashable,Transferable{
    let id: UUID
    let title: String
    let owner: String
    let note: String
    static var transferRepresentation: some TransferRepresentation{
        CodableRepresentation(contentType: .developerTask)
    }
}

extension UTType{
    static let developerTask = UTType(exportedAs: "com.elduverx.develperTask")
}

struct MockData{
    static let taskOne = DeveloperTask(id: UUID(), title: "observableObject", owner: "elduverx", note: "note placeholder")
    static let taskTwo = DeveloperTask(id: UUID(), title: "identifable object title", owner: "marix", note: "note placeholder")
    static let taskThree = DeveloperTask(id: UUID(), title: "la tercera tarea sin titulo", owner: "sin owner", note: "note placeholder")
    
}
