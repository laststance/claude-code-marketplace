# Claude Code Marketplace プラグイン動作不良の根本原因分析

## 📋 概要

`mac-notification-hook` プラグインがClaude Codeのプラグインマーケットプレイスからインストール後に動作しない問題について、体系的な調査を実施しました。

## 🔍 調査結果

### プラグイン構造の検証

プロジェクト構造は公式仕様に**完全に準拠**していることを確認しました：

```
claude-code-marketplace/
├── .claude-plugin/
│   └── marketplace.json          ✅ 正しい位置・形式
└── mac-notification-hook/
    ├── .claude-plugin/
    │   └── plugin.json            ✅ 必須フィールドすべて存在
    ├── hooks/
    │   ├── hooks.json             ✅ 正しいスキーマ
    │   └── notification-hook.sh   ✅ 実行可能なスクリプト
    └── README.md
```

#### plugin.json の検証結果
- ✅ name, version, description, license, homepage: すべて存在
- ✅ hooks: "./hooks/hooks.json" - 公式仕様通りの相対パス形式
- ✅ 構造的な問題なし

#### marketplace.json の検証結果
- ✅ plugins配列に正しく登録
- ✅ source: "./mac-notification-hook" - 正しい相対パス
- ✅ メタデータ完全

#### hooks.json の検証結果
```json
{
  "hooks": {
    "Notification": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "${CLAUDE_PLUGIN_ROOT}/hooks/notification-hook.sh"
          }
        ]
      }
    ]
  }
}
```
- ✅ Notificationイベントの定義は正しい
- ✅ `${CLAUDE_PLUGIN_ROOT}` 環境変数の使用は公式推奨
- ✅ スキーマに準拠

## 🎯 根本原因

**プラグインの構造やコードに問題はありません。Claude Code本体のバグが原因です。**

### 証拠

1. **GitHub Issue #9708の存在**
   - 同様の問題が報告されている
   - Claude Code v2.0.21で再現
   - Notificationフックがプラグインから実行されない
   - Stopフックは正常に動作することを確認済み

2. **公式ドキュメントとの整合性**
   - 当プラグインの実装は公式仕様に完全準拠
   - 構造、パス指定、環境変数の使用すべて正しい

3. **ローカルhooksとの動作差異**
   - ローカルhooks（`~/.claude/settings.json`）では正常動作
   - プラグインシステム経由では動作しない
   - 異なるコードパスで処理されることによる問題

### 技術的詳細

- **症状**: プラグインインストール時、Notificationフックが検出されるが実行されない
- **デバッグログ**: "Matched 1 unique hooks" と表示されるが、実際のコマンド実行が行われない
- **影響範囲**: プラグインマーケットプレイスからインストールされたNotificationフック限定
- **バージョン**: Claude Code v2.0.21以降で確認

## 💡 解決策

### 短期的解決策（即座に実装可能）

#### オプション1: Stopフックへの変更
```json
{
  "hooks": {
    "Stop": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "${CLAUDE_PLUGIN_ROOT}/hooks/notification-hook.sh"
          }
        ]
      }
    ]
  }
}
```
**メリット**: Stopフックはプラグインから正常に動作する
**デメリット**: セッション完了時のみ通知（Notificationイベントとは異なるタイミング）

#### オプション2: グローバルhooksとして配布
プラグインマーケットプレイスではなく、ユーザーが手動でhooksを設定する形式で配布。

**インストール手順を提供:**
```bash
# 1. リポジトリをクローン
git clone https://github.com/laststance/claude-code-marketplace.git

# 2. スクリプトをコピー
cp mac-notification-hook/hooks/notification-hook.sh ~/.claude/hooks/

# 3. ~/.claude/settings.json に追加
{
  "hooks": {
    "Notification": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "~/.claude/hooks/notification-hook.sh"
          }
        ]
      }
    ]
  }
}

# 4. hooksをリロード
claude /hooks
```

**メリット**:
- 現在でも確実に動作
- ユーザーが直接設定するため問題が少ない

**デメリット**:
- プラグインマーケットプレイスの利便性が失われる
- 手動インストールが必要

#### オプション3: PostToolUse hookを使用
```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": ".*",
        "hooks": [
          {
            "type": "command",
            "command": "${CLAUDE_PLUGIN_ROOT}/hooks/notification-hook.sh"
          }
        ]
      }
    ]
  }
}
```
**メリット**: より頻繁に発火し、実用的
**デメリット**: 元の意図（Notification専用）とは異なる

### 長期的解決策

1. **Claude CodeのGitHubリポジトリにissueを報告**
   - Issue #9708を参照・投票
   - 追加の再現ケースとして当プラグインを提示

2. **バグ修正を待つ**
   - Anthropic社による修正を待機
   - リリースノートを監視

3. **修正後の再公開**
   - バグ修正確認後、プラグインマーケットプレイスとして正式公開

## 📊 推奨アクション

### 即座に実施すべきこと

1. **README.mdの更新**
   - 現状の制限を明記
   - 手動インストール手順を追加
   - ワークアラウンドを案内

2. **代替フックの提供**
   - Stopフック版を追加ブランチで提供
   - PostToolUse版も検討

3. **Issue追跡**
   - Issue #9708を監視
   - 修正リリースの確認

### コミュニティへの貢献

1. **Issue #9708へのコメント**
   - 再現ケースとして当プラグインを報告
   - 追加のデバッグ情報を提供

2. **ドキュメント化**
   - 他の開発者への情報共有
   - ワークアラウンドのベストプラクティス公開

## 🔗 参考リソース

- [Issue #9708: Plugin Notification hook command may not be executed](https://github.com/anthropics/claude-code/issues/9708)
- [Issue #3145: Add postAllResponses hook](https://github.com/anthropics/claude-code/issues/3145)
- [Claude Code公式ドキュメント - Plugins Reference](https://docs.claude.com/en/docs/claude-code/plugins-reference)
- [Claude Code公式ドキュメント - Hooks Guide](https://docs.claude.com/en/docs/claude-code/hooks-guide)

## 📝 結論

**プラグインのコードや構造には問題がありません。** Claude Code本体のNotificationフックに関するバグが根本原因です。短期的にはワークアラウンド（手動インストールまたはStopフックへの変更）を提供し、長期的にはバグ修正を待つことを推奨します。

---

**調査実施日**: 2025-10-29
**Claude Code バージョン**: v2.0.21以降で確認されている問題
**ステータス**: 構造的問題なし / Claude Code本体のバグ待ち
