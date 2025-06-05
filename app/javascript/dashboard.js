document.addEventListener('DOMContentLoaded', () => {
    // Handle form submission
    const form = document.querySelector('.dashboard-form')
    if (form) {
        form.addEventListener('submit', (e) => {
            const requiredFields = form.querySelectorAll('[required]')
            let isValid = true

            requiredFields.forEach(field => {
                if (!field.value) {
                    isValid = false
                    field.classList.add('error')
                } else {
                    field.classList.remove('error')
                }
            })

            if (!isValid) {
                e.preventDefault()
                alert('Please fill in all required fields')
            }
        })
    }

    // Handle radio button styling
    const radioLabels = document.querySelectorAll('.radio-label')
    radioLabels.forEach(label => {
        const radio = label.querySelector('input[type="radio"]')
        if (radio) {
            radio.addEventListener('change', () => {
                radioLabels.forEach(l => l.classList.remove('selected'))
                if (radio.checked) {
                    label.classList.add('selected')
                }
            })
        }
    })
})