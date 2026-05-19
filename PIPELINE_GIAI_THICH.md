# 🏗️ Giải thích từng Stage — Pipeline V7

> Viết cho Bảo — dễ hiểu, không cần biết code

---

## Bức tranh tổng thể

```
Bạn upload PDF bản vẽ xây dựng
         ↓
   [AI đọc PDF] → hiểu bản vẽ có gì
         ↓
   [AI trích xuất số liệu] → dài, rộng, cao của cột, dầm, sàn, tường...
         ↓
   [AI kiểm tra số liệu] → coi có hợp lý không
         ↓
   [AI viết code 3D] → sinh ra file .rb cho SketchUp
         ↓
   Bạn mở SketchUp → load file → có ngay mô hình 3D
```

---

## Stage 0: "Soi" PDF (PDFForensic)

**Làm gì:** Mở file PDF ra, đếm có bao nhiêu trang, trang nào có chữ, trang nào là bản vẽ, trang nào là bảng số liệu.

**Ví dụ:** PDF 29 trang → AI phát hiện: 19 trang bảng số liệu, 4 trang mặt bằng, 4 trang chi tiết, 1 trang mặt đứng, 1 trang bìa.

**Giống như:** Bạn cầm cuốn hồ sơ thiết kế, lật từng trang để biết trang nào là gì.

---

## Stage 1: Phân loại trang (PageRouter)

**Làm gì:** Gán nhãn cho từng trang: "SCHEDULE" (bảng số liệu), "PLAN" (mặt bằng), "DETAIL" (chi tiết), "ELEVATION" (mặt đứng)...

**Tại sao cần:** Vì mỗi loại trang có cách đọc khác nhau. Bảng số liệu thì đọc số, mặt bằng thì nhìn hình.

**Giống như:** Sau khi lật hết, bạn chia ra: "Mấy trang này là bảng thép, mấy trang kia là mặt bằng tầng 1..."

---

## Stage 2: Scan từng trang (ScannerV6)

**Làm gì:** Gửi từng trang cho AI (Gemini) đọc. AI sẽ trích xuất ra các con số từ bảng số liệu.

**Ví dụ đầu ra cho 1 trang:**
```
Cột C1: 400x600mm, cao 3500mm, 4 cây
Dầm B1: 300x500mm, dài 6000mm
Sàn S1: dày 150mm
```

**Tốn thời gian nhất:** Đây là bước nặng nhất vì gọi AI 29 lần (mỗi trang 1 lần), mất ~17 phút.

**Giống như:** Bạn ngồi đọc từng trang bảng số liệu, ghi ra giấy các thông số kỹ thuật.

---

## Stage 3: Tổng hợp (SynthesizerV7)

**Làm gì:** Gom hết dữ liệu từ 29 trang lại thành 1 file JSON duy nhất, loại bỏ trùng lặp, phân loại thành: columns, beams, slabs, walls...

**Ví dụ:** Trang 5 nói cột C1 400x600, trang 12 cũng nói cột C1 → AI biết đây là 1 cột, không tạo 2 lần.

**Đầu ra:** File `Structural_model.json` chứa toàn bộ danh sách cấu kiện.

**Giống như:** Bạn ngồi tổng hợp tất cả ghi chú từ 29 trang thành 1 bảng Excel tổng.

---

## Stage 4: Kiểm tra chất lượng (ValidatorV7)

**Làm gì:** Kiểm tra các con số có hợp lý không.

**Các rule kiểm tra:**
- Cột có dày quá 1200mm không? (nếu có → warning)
- Dầm có dài quá 20m không? (nếu có → warning)
- Sàn có dày quá 500mm không?
- Có cấu kiện nào bị thiếu thông tin không?

**Kết quả:** File `Structural_validation_report.json`:
- ✅ PASS: mọi thứ OK
- ⚠️ WARN: có thứ hơi bất thường nhưng vẫn dùng được
- ❌ FAIL: có lỗi nghiêm trọng, cần sửa

**Giống như:** Kỹ sư trưởng kiểm tra lại bản vẽ trước khi thi công.

---

## Stage 5: Sinh code 3D (RubyGeneratorV5 + RubyValidator)

**Làm gì:** Từ danh sách cấu kiện, AI viết code Ruby (ngôn ngữ của SketchUp) để vẽ tự động.

**Ví dụ code sinh ra:**
```ruby
# Vẽ cột C1 400x600, cao 3500mm
model = Sketchup.active_model
entities = model.active_entities
face = entities.add_face([0,0,0], [400,0,0], [400,600,0], [0,600,0])
face.material = "Concrete"
face.pushpull(3500)
```

**Sau đó RubyValidator check:** Code có lỗi cú pháp không? Có thiếu `end` không?

**Đầu ra:** File `.rb` hoàn chỉnh, sẵn sàng load vào SketchUp.

**Giống như:** Lập trình viên viết script tự động vẽ, rồi QA check lỗi.

---

## Cách dùng thực tế

```
1. Mở app (streamlit) → upload file PDF bản vẽ
2. Tích "Force Fresh Run" (nếu muốn chạy lại từ đầu)
3. Chọn "V7 (Next-Gen Quality Gate)"
4. Nhấn "Start Conversion"
5. Đợi ~18 phút (AI scan hết trang)
6. Tải file .rb về
7. Mở SketchUp → Extensions → Ruby Console
8. Gõ: load 'đường_dẫn_đến_file.rb'
9. Enter → Mô hình 3D tự hiện ra!
10. File → Save As → .skp
```

---

## Tóm tắt bằng 1 câu

> **Pipeline V7 giống như có 1 đội kỹ sư AI: 1 người đọc bản vẽ, 1 người ghi số liệu, 1 người tổng hợp, 1 người kiểm tra, 1 người vẽ 3D — tất cả tự động từ lúc bạn upload PDF đến lúc có mô hình SketchUp.**

---

*Viết bởi Cline (Claude) — Principal AI Engineer — 19/05/2026*