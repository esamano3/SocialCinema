//
//  ReviewsViewModel.swift
//  SocialCinema
//
//  Created by Joseph Loveall (Student) on 4/18/26.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

@MainActor
class ReviewsViewModel: ObservableObject {
    @Published var reviews: [MovieReview] = []
    @Published var reviewText: String = ""
    @Published var rating: Int = 5
    @Published var errorMessage: String = ""
    @Published var isLoading: Bool = false

    private let db = Firestore.firestore()

    func loadReviews(for movieID: Int) {
        isLoading = true
        errorMessage = ""

        db.collection("reviews")
            .whereField("movieID", isEqualTo: movieID)
            .order(by: "createdAt", descending: true)
            .getDocuments { [weak self] snapshot, error in
                guard let self = self else { return }

                self.isLoading = false

                if let error = error {
                    self.errorMessage = error.localizedDescription
                    self.reviews = []
                    return
                }

                guard let documents = snapshot?.documents else {
                    self.reviews = []
                    return
                }

                self.reviews = documents.compactMap { MovieReview(document: $0) }
            }
    }

    func loadReviewsForCurrentUser() {
        guard let currentUser = Auth.auth().currentUser,
              let email = currentUser.email else {
            self.errorMessage = "You must be logged in to view your reviews."
            self.reviews = []
            return
        }

        loadReviews(forUserEmail: email)
    }

    func loadReviews(forUserEmail email: String) {
        isLoading = true
        errorMessage = ""

        db.collection("reviews")
            .whereField("userEmail", isEqualTo: email)
            .order(by: "createdAt", descending: true)
            .getDocuments { [weak self] snapshot, error in
                guard let self = self else { return }

                self.isLoading = false

                if let error = error {
                    self.errorMessage = error.localizedDescription
                    self.reviews = []
                    return
                }

                guard let documents = snapshot?.documents else {
                    self.reviews = []
                    return
                }

                self.reviews = documents.compactMap { MovieReview(document: $0) }
            }
    }

    func submitReview(for movieID: Int, movieTitle: String) {
        errorMessage = ""

        let trimmedText = reviewText.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedText.isEmpty else {
            errorMessage = "Review cannot be empty."
            return
        }

        guard let currentUser = Auth.auth().currentUser,
              let email = currentUser.email else {
            errorMessage = "You must be logged in to leave a review."
            return
        }

        let review = MovieReview(
            movieID: movieID,
            movieTitle: movieTitle,
            userEmail: email,
            reviewText: trimmedText,
            rating: rating
        )

        db.collection("reviews").addDocument(data: review.dictionary) { [weak self] error in
            guard let self = self else { return }

            if let error = error {
                self.errorMessage = error.localizedDescription
                return
            }

            self.reviewText = ""
            self.rating = 5
            self.loadReviews(for: movieID)
        }
    }
}
