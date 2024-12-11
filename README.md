# docker-test

TeX LiveをDocker上で動かすためのコンテナビルド用リポジトリ

| ver.  |  release   | ubuntu | TeX Live |    Arch.     | repository                                                                                           |
| :---: | :--------: | :----: | :------: | :----------: | ---------------------------------------------------------------------------------------------------- |
| 0.1.0 | 2024/9/30  | 22.04  |   2024   |    amd64     | [ghcr.io](https://github.com/HiroTNK1118/docker-test/pkgs/container/docker-test/281401957?tag=0.1.0) |
| 0.2.0 | 2024/10/7  | 22.04  |   2024   |    amd64     | [ghcr.io](https://github.com/HiroTNK1118/docker-test/pkgs/container/docker-test/285022331?tag=0.2.0) |
| 0.3.0 | 2024/10/8  | 22.04  |   2024   |    amd64     | [ghcr.io](https://github.com/HiroTNK1118/docker-test/pkgs/container/docker-test/285022331?tag=0.2.0) |
| 0.4.0 | 2024/10/8  | 22.04  |   2024   | amd64, arm64 | [ghcr.io](https://github.com/HiroTNK1118/docker-test/pkgs/container/docker-test/285739845?tag=0.4.0) |
| 0.5.0 | 2024/11/10 | 22.04  |   2024   | amd64, arm64 | [ghcr.io](https://github.com/HiroTNK1118/docker-test/pkgs/container/docker-test/303239648?tag=0.5.0) |
| 0.6.0 | 2024/12/11  | 24.04  |   2024   | amd64, arm64 | [ghcr.io]()                                                                                          |

## 概要

- LaTeX実行環境のためのDockerイメージです
- ubuntu上にTeX Liveをインストールしています
- マルチアーキテクチャ対応しています
  - amd64 (intel系, AMD系)
  - arm64 (Apple Silicon, Snapdragon X)

## 使い方

[卒論執筆テンプレートのリポジトリ](https://github.com/HiroTNK1118/latex-template-kanekolab)を参照ください

## 収録される主なLaTeXパッケージ

※`collection-__`に含まれるパッケージは[こちら](https://gist.github.com/nox40/6255eef548ccad9881ce7202e3bb75dd#file-collection-depends-md)を参照ください

- `collection-bibtexextra`
- `collection-latexextra`
- `collection-latexrecommended`
- `collection-luatex`
- `collection-langjapanese`
- `collection-mathscience`
- `collection-pictures`
- `latexmk`
- `latexdiff`
- `stix2-otf` (v0.5.0~)
- `latexindent`
