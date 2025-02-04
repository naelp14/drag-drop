import SwiftUI

struct Chain: Hashable {
    let atom: String
    let child: [String]
}

struct AminoAcidModel: Hashable {
    let name: String
    let category: String
    let correctRGroup: [Chain]
}

enum AminoAcidType: String, CaseIterable {
    // Nonpolar, Aliphatic
    case glycine = "Glycine"
    case alanine = "Alanine"
    case valine = "Valine"
    case leucine = "Leucine"
    case isoleucine = "Isoleucine"

    // Aromatic
    case phenylalanine = "Phenylalanine"
    case tyrosine = "Tyrosine"
    case tryptophan = "Tryptophan"
    
    // Polar, Uncharged
    case serine = "Serine"
    case threonine = "Threonine"
    case cysteine = "Cysteine"
    case asparagine = "Asparagine"
    case glutamine = "Glutamine"

    // Acidic (Negatively Charged)
    case aspartate = "Aspartate"
    case glutamate = "Glutamate"

    // Basic (Positively Charged)
    case lysine = "Lysine"
    case arginine = "Arginine"
    case histidine = "Histidine"
    
    var model: AminoAcidModel {
        switch self {
        case .glycine:
            AminoAcidModel(name: "Glycine", category: "Nonpolar, Aliphatic", correctRGroup: [
                Chain(atom: "H", child: [])
            ])
        case .alanine:
            AminoAcidModel(name: "Alanine", category: "Nonpolar, Aliphatic", correctRGroup: [
                Chain(atom: "CH3", child: [])
            ])
        case .valine:
            AminoAcidModel(name: "Valine", category: "Nonpolar, Aliphatic", correctRGroup: [
                Chain(atom: "CH", child: ["CH3", "CH3"])
            ])
        case .leucine:
            AminoAcidModel(name: "Leucine", category: "Nonpolar, Aliphatic", correctRGroup: [
                Chain(atom: "CH2", child: []),
                Chain(atom: "CH", child: ["CH3", "CH3"])
            ])
        case .isoleucine:
            AminoAcidModel(name: "Isoleucine", category: "Nonpolar, Aliphatic", correctRGroup: [
                Chain(atom: "CH", child: ["CH3"]),
                Chain(atom: "CH2", child: []),
                Chain(atom: "CH3", child: [])
            ])
        case .phenylalanine:
            AminoAcidModel(name: "Phenylalanine", category: "Aromatic", correctRGroup: [
                Chain(atom: "C6H5", child: [])
            ])
        case .tyrosine:
            AminoAcidModel(name: "Tyrosine", category: "Aromatic", correctRGroup: [
                Chain(atom: "C6H4", child: []),
                Chain(atom: "OH", child: [])
            ])
        case .tryptophan:
            AminoAcidModel(name: "Tryptophan", category: "Aromatic", correctRGroup: [
                Chain(atom: "C8H6N", child: [])
            ])
        case .serine:
            AminoAcidModel(name: "Serine", category: "Polar, Uncharged", correctRGroup: [
                Chain(atom: "CH2", child: []),
                Chain(atom: "OH", child: [])
            ])
        case .threonine:
            AminoAcidModel(name: "Threonine", category: "Polar, Uncharged", correctRGroup: [
                Chain(atom: "CH", child: ["CH3"]),
                Chain(atom: "OH", child: [])
            ])
        case .cysteine:
            AminoAcidModel(name: "Cysteine", category: "Polar, Uncharged", correctRGroup: [
                Chain(atom: "CH2", child: []),
                Chain(atom: "SH", child: [])
            ])
        case .asparagine:
            AminoAcidModel(name: "Asparagine", category: "Polar, Uncharged", correctRGroup: [
                Chain(atom: "CH2", child: []),
                Chain(atom: "CONH2", child: [])
            ])
        case .glutamine:
            AminoAcidModel(name: "Glutamine", category: "Polar, Uncharged", correctRGroup: [
                Chain(atom: "CH2", child: []),
                Chain(atom: "CH2", child: []),
                Chain(atom: "CONH2", child: [])
            ])
        case .aspartate:
            AminoAcidModel(name: "Aspartate", category: "Acidic (Negative)", correctRGroup: [
                Chain(atom: "CH2", child: []),
                Chain(atom: "COO-", child: [])
            ])
        case .glutamate:
            AminoAcidModel(name: "Glutamate", category: "Acidic (Negative)", correctRGroup: [
                Chain(atom: "CH2", child: []),
                Chain(atom: "CH2", child: []),
                Chain(atom: "COO-", child: [])
            ])
        case .lysine:
            AminoAcidModel(name: "Lysine", category: "Basic (Positive)", correctRGroup: [
                Chain(atom: "CH2", child: []),
                Chain(atom: "CH2", child: []),
                Chain(atom: "CH2", child: []),
                Chain(atom: "CH2", child: []),
                Chain(atom: "NH3+", child: [])
            ])
        case .arginine:
            AminoAcidModel(name: "Arginine", category: "Basic (Positive)", correctRGroup: [
                Chain(atom: "CH2", child: []),
                Chain(atom: "CH2", child: []),
                Chain(atom: "CH2", child: []),
                Chain(atom: "C(NH2)2", child: ["NH"])
            ])
        case .histidine:
            AminoAcidModel(name: "Histidine", category: "Basic (Positive)", correctRGroup: [
                Chain(atom: "CH2", child: []),
                Chain(atom: "C3H3N2", child: [])
            ])
        }
    }
}
