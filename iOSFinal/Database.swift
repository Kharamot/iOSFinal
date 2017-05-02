//
//  Database.swift
//  iOSFinal
//
//  Created by Kameron Haramoto on 4/29/17.
//  Copyright © 2017 Kameron Haramoto. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class Database {
    
    static let db = Database() // singleton -- shared instance used throughout app
    
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    func createQuestion (_ question: String, _ answer: String, _ a1Answer: String, _ a2Answer: String, _ a3Answer: String, _ file: String, _ voice: Bool) {
        let context = getContext()
        
        let fetchRequest: NSFetchRequest<Question> = Question.fetchRequest()
        let questPred = NSPredicate(format: "question == %@", argumentArray: [question])
        let answerPred = NSPredicate(format: "c_answer == %@", argumentArray: [answer])
        let a1AnswerPred = NSPredicate(format: "a1_answer == %@", argumentArray: [a1Answer])
        let a2AnswerPred = NSPredicate(format: "a2_answer == %@", argumentArray: [a2Answer])
        let a3AnswerPred = NSPredicate(format: "a3_answer == %@", argumentArray: [a3Answer])
        let filepred = NSPredicate(format: "file == %@", argumentArray: [file])
        let isVoicepred = NSPredicate(format: "is_voice == %@", argumentArray: [voice])
        
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [questPred, answerPred, a1AnswerPred, a2AnswerPred, a3AnswerPred, filepred, isVoicepred])
        fetchRequest.predicate = predicate
        
        do {
            let searchResult = try context.fetch(fetchRequest) as [NSManagedObject]
            if (searchResult.count <= 0) { // only insert if it doesnt exist already
                // retrieve the entity
                let entity = NSEntityDescription.entity(forEntityName: "Question", in: context)
                
                let QDb = NSManagedObject(entity: entity!, insertInto: context)
                
                // set the entity values
                QDb.setValue(question, forKey: "question")
                QDb.setValue(answer, forKey: "c_answer")
                QDb.setValue(a1Answer, forKey: "a1_answer")
                QDb.setValue(a2Answer, forKey: "a2_answer")
                QDb.setValue(a3Answer, forKey: "a3_answer")
                QDb.setValue(file, forKey: "file")
                QDb.setValue(voice, forKey: "is_voice")

                
                do {
                    try context.save()
                    print("Question saved!")
                } catch let error as NSError  {
                    print("Could not save \(error), \(error.userInfo)")
                } catch {
                    
                }
            }
        } catch {
            print("Error with request \(error)")
        }
    }
    
    func fetchQuestions () -> [NSManagedObject]? {
        let fetchRequest: NSFetchRequest<Question> = Question.fetchRequest()
        
        do {
            // get the results
            let searchResults = try getContext().fetch(fetchRequest)
            
            print ("num of bm results = \(searchResults.count)")
            
            // convert to NSManagedObejct to use 'for' loops
            for q in searchResults as [NSManagedObject] {
                print ("\(q.value(forKey: "question")!) \(q.value(forKey: "c_answer")!)")
            }
            return searchResults as [NSManagedObject]
        } catch {
            print("Error with request \(error)")
        }
        return nil
    }
}
