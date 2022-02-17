
import Foundation
import CoreData


public class PictureInfo: NSManagedObject {
    convenience init() {
        
        // Создание нового объекта
        self.init(entity: CoreDataManager.instance.entityForName(entityName: "PictureInfo"), insertInto: CoreDataManager.instance.managedObjectContext)
        
}
    // Извлечение записей
    func getDataPictureInfo() -> [NSFetchRequestResult] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PictureInfo")
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try CoreDataManager.instance.managedObjectContext.fetch(fetchRequest)
            return results
        }catch {
            print(error)
            return []
        }
    }
}
