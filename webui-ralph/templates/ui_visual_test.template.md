# UI Visual Test Checklist

Generated: {{date}}
Project: {{project_name}}

## Instructions

1. 各テストケースを実行
2. スクリーンショットを撮影 (`claudedocs/screenshots/`)
3. Triple-Criteria評価で95%+信頼度を確認
4. 確認後、`[x]` にチェック
5. **全項目チェック完了まで継続**

---

## 1. Page Coverage

### Discovered Pages
<!-- プロジェクトのルートから自動検出 -->
- [ ] Home / Landing
- [ ] Dashboard
- [ ] Settings
- [ ] Profile
- [ ] Login / Auth
- [ ] {{additional_pages}}

### Per-Page Verification
各ページで:
- [ ] 初期ロード状態の撮影・検証
- [ ] 全セクションがviewport内に表示
- [ ] 画像・アセットの欠損なし

---

## 2. Long Content Tests

### 300+ Character Input
- [ ] テキスト入力フィールドに300文字以上
- [ ] テキストエリアに300文字以上
- [ ] 表示専用エリアに300文字以上のコンテンツ

### Overflow Handling
- [ ] テキストの省略表示 (ellipsis)
- [ ] 省略時のツールチップ表示
- [ ] 必要に応じた横スクロール
- [ ] 適切なword-break動作

---

## 3. Many Items / Empty States

### Many Items (50+)
- [ ] 50+アイテムのリスト表示
- [ ] 100+行のテーブル表示
- [ ] フルページのグリッド表示
- [ ] ページネーション境界 (first/last/middle)

### Empty States
- [ ] 検索結果なし
- [ ] リスト/テーブルが空
- [ ] フィルター結果なし
- [ ] 新規ユーザーの初期空状態

---

## 4. Interactive States

### Hover States
- [ ] Primary Button hover
- [ ] Secondary Button hover
- [ ] Ghost/Outline Button hover
- [ ] Navigation Link hover
- [ ] Inline Link hover
- [ ] Card hover (if clickable)
- [ ] Table Row hover (if applicable)
- [ ] Menu Item hover

### Focus States
- [ ] Text Input focus
- [ ] Textarea focus
- [ ] Button focus (keyboard)
- [ ] Link focus (keyboard navigation)
- [ ] Dropdown/Select focus
- [ ] Custom component focus

### Active/Pressed States
- [ ] Button press feedback
- [ ] Toggle/Switch active state
- [ ] Tab active state
- [ ] Pill/Chip active state
- [ ] Accordion expanded state
- [ ] Checkbox/Radio checked state

---

## 5. Forms & Validation

### Input Field States
- [ ] Empty with placeholder
- [ ] Filled with content
- [ ] Error state with message
- [ ] Success/Valid state
- [ ] Disabled state

### Validation Messages
- [ ] Required field error
- [ ] Format validation error (email, phone, etc.)
- [ ] Min/Max length error
- [ ] Server-side error display
- [ ] Success confirmation message

---

## 6. Filters & Search

### Filter Display
- [ ] All filters visible and accessible
- [ ] Active filter indication (badge/highlight)
- [ ] Filter count/badge
- [ ] Clear all filters button

### Filter Behavior
- [ ] Single filter applied
- [ ] Multiple filters combined
- [ ] Filter produces zero results
- [ ] Reset to default state
- [ ] Filter persists on navigation (if applicable)

---

## 7. Scroll Behavior

### Long Content Scrolling
- [ ] Smooth scroll behavior
- [ ] Scroll position indicator (if applicable)
- [ ] Back-to-top button (if exists)
- [ ] Infinite scroll loading (if applicable)

### Sticky/Fixed Elements
- [ ] Header remains visible on scroll
- [ ] Sidebar remains accessible
- [ ] Action buttons accessible during scroll
- [ ] Footer behavior on scroll

---

## 8. Keyboard Accessibility

### Tab Navigation
- [ ] Tab order is logical (left-to-right, top-to-bottom)
- [ ] Skip links functional (if exists)
- [ ] No keyboard traps (except modals)

### Keyboard Shortcuts
- [ ] Shortcuts work outside text inputs
- [ ] Shortcuts DISABLED inside text inputs
- [ ] No accidental shortcut triggers during typing
- [ ] Escape closes modals/dropdowns

### Focus Management
- [ ] Focus trap in modals
- [ ] Focus returns after modal close
- [ ] Focus visible on all interactive elements

---

## 9. Loading & Transitions

### Loading Indicators
- [ ] Page load skeleton/spinner
- [ ] Button loading state
- [ ] Data fetch loading indicator
- [ ] Lazy load indicators (images, components)

### Transitions
- [ ] Modal open animation
- [ ] Modal close animation
- [ ] Accordion expand/collapse
- [ ] Tab switch transition
- [ ] Route transition (if animated)
- [ ] Dropdown open/close

---

## 10. Responsive Breakpoints

### Desktop (1440px+)
- [ ] Full layout visible
- [ ] Sidebar expanded
- [ ] Multi-column layout (if applicable)
- [ ] All navigation visible

### Tablet (768px - 1024px)
- [ ] Adjusted layout
- [ ] Sidebar collapsible or hidden
- [ ] Touch targets adequate (44x44px)
- [ ] No horizontal overflow

### Mobile (< 768px)
- [ ] Single column layout
- [ ] Mobile navigation (hamburger)
- [ ] Touch targets 44x44px minimum
- [ ] No horizontal scroll
- [ ] Bottom navigation accessible (if applicable)

---

## 11. Visual Design Quality

### Color & Contrast
- [ ] Colors feel natural (not oversaturated)
- [ ] Sufficient contrast for readability
- [ ] Dark mode works correctly (if applicable)
- [ ] No color inconsistencies

### Layout & Spacing
- [ ] Consistent padding/margins
- [ ] Elements align to grid (4px/8px)
- [ ] No unexpected gaps or overlaps
- [ ] Proper vertical rhythm

### Typography
- [ ] Font sizes readable
- [ ] Clear hierarchy (headings, body, captions)
- [ ] Line heights comfortable
- [ ] No text overflow or truncation issues

### Icons & Images
- [ ] Icons proportionate to context
- [ ] Images load correctly
- [ ] No broken image placeholders
- [ ] Proper aspect ratios maintained

---

## Summary

| Category | Total | Verified |
|----------|-------|----------|
| Pages | - | - |
| Long Content | 7 | - |
| Many Items / Empty | 8 | - |
| Interactive States | 20 | - |
| Forms | 10 | - |
| Filters | 9 | - |
| Scroll | 8 | - |
| Keyboard | 9 | - |
| Loading / Transitions | 10 | - |
| Responsive | 13 | - |
| Visual Design | 16 | - |

**Total Items**: ~110 (+ pages)
**Target Coverage**: 80%+ of reproducible UI patterns

---

## Final Verification

Before outputting `<promise>COMPLETE</promise>`:

- [ ] ALL items above are checked `[x]`
- [ ] ALL screenshots in `claudedocs/screenshots/` have `verify_` prefix
- [ ] Final test run passed
- [ ] 95%+ confidence in visual quality across all pages

**Only when ALL above conditions are TRUE, output:**

```xml
<promise>COMPLETE</promise>
```
