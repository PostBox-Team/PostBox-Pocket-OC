//
//  RatingSplashView.swift
//  PostBox
//
//  Created by Polarizz on 2/17/21.
//  Copyright © 2022 postboxteam. All rights reserved.
//

import SwiftUI
import FirebaseFirestore

struct ReviewView: View {
    
    @Environment(\.colorScheme) var colorScheme

    @State var reviewContent: String = ""
    @State var reviewAuthor: String = ""
    @State var stars = 0
    
    @State private var showReviewSort = false
    @State private var sortType = ReviewSortType.recent
    @State private var initialRating = false
    @State private var submitted = false
    @State private var submitting = false
    @State private var showReviewEdit = false
    
    @Binding var showReviewSplash: Bool
    
    @ObservedObject var package: Package
    
    init(showReviewSplash: Binding<Bool>, _ package: Package) {
        self._showReviewSplash = showReviewSplash
        self.package = package
    }
    
    var body: some View {
        VStack(spacing: 0) {
            SplashHeader("Review L")
                .padding(.horizontal, UIConstants.margin)

            ScrollView {
                VStack(alignment: .center, spacing: 0) {
                    if showReviewEdit {
                        VStack(alignment: .center, spacing: 0) {
                            VStack(alignment: .leading, spacing: 0) {
                                TextField(LocalizedStringKey("Written by L"), text: $reviewAuthor)
                                    .font(.system(size: Types.body))
                                    .padding(.bottom, 3)
                                
                                MultilineTextField("Type your review L", text: $reviewContent)
                                    .font(.system(size: Types.body))
                                    .padding(.leading, -4)
                                    .padding(.bottom, -7)
                                
                                HStack(spacing: 0) {
                                    HStack(spacing: 5) {
                                        ForEach(0..<5, id: \.self) { i in
                                            Image(systemName: "star.fill")
                                                .foregroundColor(i < stars ? Color.accentColor : Color(.tertiaryLabel))
                                                .onTapGesture {
                                                    if !(submitted || submitting) {
                                                        stars = i + 1
                                                    }
                                                }
                                        }
                                    }
                                    .font(.system(size: Types.title3-1))
                                    
                                    Spacer()
                                    
                                    Button(action: {
                                        if reviewAuthor == "" || reviewContent == "" || stars == 0 { return }
                                        
                                        submitting = true
                                        
                                        let database = Firestore.firestore()
                                        database.collection("package_data").document(package.identifier).setData([:]) { _ in
                                            database.collection("package_data").document(package.identifier).collection("reviews")
                                                .addDocument(data: [
                                                    "author": reviewAuthor,
                                                    "body": reviewContent,
                                                    "rating": stars,
                                                    "time": Date(),
                                                    "approved": false
                                                ]) { _ in
                                                    submitting = false
                                                    submitted = true
                                                    package.loadReviews()
                                                }
                                        }
                                    }) {
                                        Image(systemName: submitted ? "checkmark" : "arrow.right")
                                            .font(.system(size: UIConstants.footnote).weight(.medium))
                                            .frame(width: UIFont.preferredFont(forTextStyle: .footnote).pointSize)
                                            .foregroundColor((reviewAuthor == "" || reviewContent == "" || stars == 0 || submitting) ? Color(.tertiaryLabel) : .primary)
                                            .padding(7)
                                            .background(Color(.tertiarySystemBackground))
                                            .clipShape(Circle())
                                            .overlay(
                                                Circle()
                                                    .stroke(Color(.tertiaryLabel), lineWidth: 1)
                                                    .opacity(0.25)
                                            )
                                            .contentShape(Rectangle())
                                            .animation(.spring(response: 0.2, dampingFraction: 1))
                                    }
                                    .buttonStyle(DefaultButtonStyle())
                                    .disabled(submitting || submitted)
                                }
                                .padding(.top, 9)
                            }
                            .padding(.horizontal, UIConstants.margin)
                        }
                    } else {
                        if package.reviews.count > 0 {
                            ReviewScore(package.meanScore)
                                .padding(.vertical, 40)
                                .padding(.horizontal, UIConstants.margin)
                        }
                        
                        if package.reviews.count != 0 {
                            VStack(alignment: .leading, spacing: 0) {
                                reviewDropdown
                                    .padding(.horizontal, UIConstants.margin)
                                    .padding(.top, 24)
                                    .padding(.bottom, 21)
                                
                                VStack(spacing: 13) {
                                    ForEach(package.reviews.sorted {
                                        Review.sort(with: sortType, lhs: $0, rhs: $1)
                                    }) { review in
                                        ReviewCard(
                                            content: review.body,
                                            author: review.author,
                                            rating: review.rating.doubleGuess ?? 5,
                                            time: review.time
                                        )
                                    }
                                    .animation(.spring(response: 0.3, dampingFraction: 0.9), value: sortType)
                                }
                                .padding(.horizontal, UIConstants.margin)
                            }
                        } else {
                            NullCard(
                                symbol: "text.bubble",
                                title: "No Reviews L",
                                desc: "Be the first to review this package. L",
                                custom: false
                            )
                            .padding(.horizontal, UIConstants.margin)
                        }
                    }
                }
                .padding(.vertical, UIConstants.margin)
                .padding(.bottom, 80)
            }
                        
            LongButton(
                text: "New Review L",
                foreground: .white,
                background: .primary
            )
            .opacity(0)
            .padding([.horizontal, .bottom], UIConstants.margin)

        }
        .overlay(
            Grabber()
            ,
            alignment: .top
        )
        .overlay(
            VStack(spacing: 0) {
                LinearGradient(colors: [Color.primaryBackground, Color.primaryBackground.opacity(0)], startPoint: .bottom, endPoint: .top)
                    .padding(.horizontal, UIConstants.margin)
                    .frame(height: 80)
                
                VStack(spacing: 0) {
                    Button(action: {
                        withAnimation(.spring(response: 0.3, dampingFraction: 1)) {
                            showReviewEdit.toggle()
                        }
                    }) {
                        CenteredLongButton(
                            text: showReviewEdit ? "Discard Review L" : "New Review L",
                            foreground: showReviewEdit ? Color.accentColor : Color(.systemBackground),
                            background: showReviewEdit ? Color(.quaternarySystemFill) : Color.accentColor
                        )
                    }
                    .buttonStyle(DefaultButtonStyle())
                }
                .padding([.horizontal, .bottom], UIConstants.margin)
                .background(Color.primaryBackground.edgesIgnoringSafeArea(.all))
            }
            ,alignment: .bottom
        )
        .navigationBarHidden(true)
        .navigationBarTitle("", displayMode: .large)
        .background(Color.primaryBackground.edgesIgnoringSafeArea(.all))
        .onAppear {
            package.loadReviews()
        }
    }
    
    private var reviewDropdown: some View {
        VStack(alignment: .leading, spacing: 0) {
            if #available(iOS 14, *) {
                Menu {
                    Button(action: { sortType = .recent }) {
                        Text("Most Recent")
                    }
                    Button(action: { sortType = .favorable }) {
                        Text("Most Stars")
                    }
                    Button(action: { sortType = .critical }) {
                        Text("Least Stars")
                    }
                } label: {
                    DropDownSectionHeader(sortType == .recent ? "Most Recent" : (sortType == .favorable ? "Most Stars" : "Least Stars"))
                        .animation(.spring(response: 0.2, dampingFraction: 1), value: sortType)
                }
            } else {
                Button(action: {
                    showReviewSort = true
                }) {
                    DropDownSectionHeader(sortType == .recent ? "Most Recent" : (sortType == .favorable ? "Most Stars" : "Least Stars"))
                        .animation(.spring(response: 0.2, dampingFraction: 1), value: sortType)
                }
                .buttonStyle(DefaultButtonStyle())
                .actionSheet(isPresented: $showReviewSort) {
                    ActionSheet(
                        title: Text("Sort reviews by"),
                        buttons: [
                            .cancel(),
                            .default(Text("Most Recent")) { sortType = .recent },
                            .default(Text("Most Stars")) { sortType = .favorable },
                            .default(Text("Least Stars")) { sortType = .critical }
                        ]
                    )
                }
            }
        }
    }
}
